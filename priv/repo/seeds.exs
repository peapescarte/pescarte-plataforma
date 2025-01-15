# priv/repo/seeds.exs

# Carregar o código necessário
alias Pescarte.Municipios
alias Pescarte.Database.Repo

# Carregar os seeders personalizados
alias Seeder.MunicipiosSeeder
alias Seeder.UnitSeeder
alias Seeder.DocumentTypeSeeder
alias Seeder.DocumentSeeder

# Definir uma função para facilitar o processo de inserção e captura de erros
defmodule SeederRunner do
  def insert_records(records, insert_fun, error_message) do
    Enum.map(records, fn record ->
      case insert_fun.(record) do
        {:ok, inserted_record} ->
          inserted_record

        {:error, changeset} ->
          IO.puts("Erro ao inserir #{error_message}: #{inspect(record)}")
          IO.inspect(changeset.errors)
          nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end
end

# Iniciar o SeederRunner
import SeederRunner

# 1. Truncar as tabelas necessárias
Repo.query!("TRUNCATE TABLE documents, units, municipios, document_types RESTART IDENTITY CASCADE")

# 2. Inserir Tipos de Documento
IO.puts("Inserindo Tipos de Documento...")
document_types = DocumentTypeSeeder.entries()

inserted_document_types =
  insert_records(document_types, fn dt ->
    Municipios.create_document_type(%{name: dt.name})
  end, "Tipo de Documento")

# 3. Inserir Municípios
IO.puts("Inserindo Municípios...")
municipios = MunicipiosSeeder.entries()

inserted_municipios =
  insert_records(municipios, fn municipio ->
    Municipios.create_municipio(%{
      name: municipio.name,
      created_by: municipio.created_by,
      updated_by: municipio.updated_by
    })
  end, "Município")

# 4. Inserir Unidades
IO.puts("Inserindo Unidades...")
units = UnitSeeder.entries(inserted_municipios)

inserted_units =
  insert_records(units, fn unit ->
    Municipios.create_unit(%{
      municipio_id: unit.municipio_id,
      name: unit.name,
      situation: unit.situation,
      next_step: unit.next_step,
      created_by: unit.created_by,
      updated_by: unit.updated_by
    })
  end, "Unidade")

# 5. Inserir Documentos
IO.puts("Inserindo Documentos...")
documents = DocumentSeeder.entries(inserted_municipios, inserted_units, inserted_document_types)

inserted_documents =
  insert_records(documents, fn doc ->
    Municipios.create_document(%{
      unit_id: doc.unit_id,
      document_type_id: doc.document_type_id,
      status: doc.status,
      document_link: doc.document_link,
      created_by: doc.created_by,
      updated_by: doc.updated_by
    })
  end, "Documento")

# 6. Resultado Final
IO.puts("----- SEEDS INSERIDOS -----")
IO.inspect(inserted_document_types, label: "Tipos de Documento")
IO.inspect(inserted_municipios, label: "Municípios")
IO.inspect(inserted_units, label: "Unidades")
IO.inspect(inserted_documents, label: "Documentos")
