# priv/repo/seeds.exs

# Carregar o código necessário
alias Pescarte.Municipios
alias Pescarte.Database.Repo

# Carregar os seeders personalizados
alias Seeder.{MunicipiosSeeder, UnitSeeder, DocumentTypeSeeder, DocumentSeeder, SeederRunner}

# Definir um usuário padrão para created_by e updated_by
default_user_id = "00000000-0000-0000-0000-000000000001"

# 1. Truncar as tabelas necessárias
Repo.query!(
  "TRUNCATE TABLE documents, units, municipios, document_types RESTART IDENTITY CASCADE"
)

# 2. Inserir Tipos de Documento
IO.puts("Inserindo Tipos de Documento...")
document_types = DocumentTypeSeeder.entries()

inserted_document_types =
  SeederRunner.insert_records(
    document_types,
    fn dt ->
      Municipios.create_document_type(%{
        name: dt.name,
        created_by: default_user_id,
        updated_by: default_user_id
      })
    end,
    "Tipo de Documento"
  )

# 3. Inserir Municípios
IO.puts("Inserindo Municípios...")
municipios = MunicipiosSeeder.entries()

inserted_municipios =
  SeederRunner.insert_records(
    municipios,
    fn municipio ->
      Municipios.create_municipio(%{
        name: municipio.name,
        created_by: default_user_id,
        updated_by: default_user_id
      })
    end,
    "Município"
  )

# 4. Inserir Unidades
IO.puts("Inserindo Unidades...")
units = UnitSeeder.entries(inserted_municipios)

inserted_units =
  SeederRunner.insert_records(
    units,
    fn unit ->
      Municipios.create_unit(%{
        municipio_id: unit.municipio_id,
        name: unit.name,
        situation: unit.situation,
        next_step: unit.next_step,
        created_by: default_user_id,
        updated_by: default_user_id
      })
    end,
    "Unidade"
  )

# 5. Inserir Documentos
IO.puts("Inserindo Documentos...")
documents = DocumentSeeder.entries(inserted_municipios, inserted_units, inserted_document_types)

inserted_documents =
  SeederRunner.insert_records(
    documents,
    fn doc ->
      Municipios.create_document(%{
        unit_id: doc.unit_id,
        document_type_id: doc.document_type_id,
        status: doc.status,
        document_link: doc.document_link,
        created_by: default_user_id,
        updated_by: default_user_id
      })
    end,
    "Documento"
  )

# 6. Resultado Final
IO.puts("----- SEEDS INSERIDOS -----")
IO.inspect(inserted_document_types, label: "Tipos de Documento")
IO.inspect(inserted_municipios, label: "Municípios")
IO.inspect(inserted_units, label: "Unidades")
IO.inspect(inserted_documents, label: "Documentos")
