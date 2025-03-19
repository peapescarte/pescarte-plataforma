defmodule Seeder.MunicipiosSeeder do
  alias Pescarte.Municipios.Municipio

  def entries do
    [
      %Municipio{
        name: "Armação dos Búzios",
        created_by: Ecto.UUID.generate(),
        updated_by: Ecto.UUID.generate()
      },
      %Municipio{
        name: "Arraial do Cabo",
        created_by: Ecto.UUID.generate(),
        updated_by: Ecto.UUID.generate()
      },
      %Municipio{
        name: "Cabo Frio",
        created_by: Ecto.UUID.generate(),
        updated_by: Ecto.UUID.generate()
      },
      %Municipio{
        name: "Campos dos Goytacazes",
        created_by: Ecto.UUID.generate(),
        updated_by: Ecto.UUID.generate()
      },
      %Municipio{
        name: "Carapebus",
        created_by: Ecto.UUID.generate(),
        updated_by: Ecto.UUID.generate()
      },
      %Municipio{
        name: "Macaé",
        created_by: Ecto.UUID.generate(),
        updated_by: Ecto.UUID.generate()
      },
      %Municipio{
        name: "Quissamã",
        created_by: Ecto.UUID.generate(),
        updated_by: Ecto.UUID.generate()
      },
      %Municipio{
        name: "Rio das Ostras",
        created_by: Ecto.UUID.generate(),
        updated_by: Ecto.UUID.generate()
      },
      %Municipio{
        name: "São Francisco de Itabapoana",
        created_by: Ecto.UUID.generate(),
        updated_by: Ecto.UUID.generate()
      },
      %Municipio{
        name: "São João da Barra",
        created_by: Ecto.UUID.generate(),
        updated_by: Ecto.UUID.generate()
      }
    ]
  end
end
