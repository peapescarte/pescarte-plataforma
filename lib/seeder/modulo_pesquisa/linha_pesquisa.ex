defmodule Seeder.ModuloPesquisa.LinhaPesquisa do
  alias Pescarte.Database.Repo.Replica
  alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.ModuloPesquisa.Models.NucleoPesquisa

  @behaviour Seeder.Entry

  defp nucleo_pesquisa_by(letra: letra) do
    Replica.get_by(NucleoPesquisa, letra: letra)
  end

  @impl true
  def entries do
    [
      %LinhaPesquisa{
        numero: 1,
        desc: Faker.Lorem.sentence(1..25),
        desc_curta: Faker.Lorem.sentence(1..10),
        nucleo_pesquisa: nucleo_pesquisa_by(letra: "A")
      },
      %LinhaPesquisa{
        numero: 2,
        desc: Faker.Lorem.sentence(1..25),
        desc_curta: Faker.Lorem.sentence(1..10),
        nucleo_pesquisa: nucleo_pesquisa_by(letra: "B")
      },
      %LinhaPesquisa{
        numero: 3,
        desc: Faker.Lorem.sentence(1..25),
        desc_curta: Faker.Lorem.sentence(1..10),
        nucleo_pesquisa: nucleo_pesquisa_by(letra: "C")
      },
      %LinhaPesquisa{
        numero: 4,
        desc: Faker.Lorem.sentence(1..25),
        desc_curta: Faker.Lorem.sentence(1..10),
        nucleo_pesquisa: nucleo_pesquisa_by(letra: "D")
      }
    ]
  end
end
