defmodule Seeder.ModuloPesquisa.NucleoPesquisa do
  alias Pescarte.ModuloPesquisa.Models.NucleoPesquisa

  @behaviour Seeder.Entry

  @impl true
  def entries do
    [
      %NucleoPesquisa{
        nome: Faker.Lorem.sentence(1..8),
        desc: Faker.Lorem.sentence(1..25),
        letra: "A"
      },
      %NucleoPesquisa{
        nome: Faker.Lorem.sentence(1..8),
        desc: Faker.Lorem.sentence(1..25),
        letra: "B"
      },
      %NucleoPesquisa{
        nome: Faker.Lorem.sentence(1..8),
        desc: Faker.Lorem.sentence(1..25),
        letra: "C"
      },
      %NucleoPesquisa{
        nome: Faker.Lorem.sentence(1..8),
        desc: Faker.Lorem.sentence(1..25),
        letra: "D"
      }
    ]
  end
end
