defmodule Seeder.ModuloPesquisa.NucleoPesquisa do
  alias Pescarte.ModuloPesquisa.Models.NucleoPesquisa

  @behaviour Seeder.Entry

  @impl true
  def entries do
    [
      %NucleoPesquisa{
        nome: "Voluptatem eaque aliquam error.",
        desc: "Provident libero aliquid impedit explicabo voluptatibus ea fugit atque!",
        letra: "A"
      },
      %NucleoPesquisa{
        nome: "In tempore?",
        desc: "Culpa vero est perferendis natus aut.",
        letra: "B"
      },
      %NucleoPesquisa{
        nome: "Voluptatem nobis molestias.",
        desc: "Cumque commodi odio illum distinctio consequatur?",
        letra: "C"
      },
      %NucleoPesquisa{
        nome: "Sit qui nesciunt sint?",
        desc:
          "Non veritatis similique exercitationem similique expedita et eos corporis architecto.",
        letra: "D"
      }
    ]
  end
end
