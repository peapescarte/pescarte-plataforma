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
        desc:
          "Praesentium architecto est fugit modi repudiandae amet architecto dolorem corrupti voluptas consequatur eveniet?",
        desc_curta: "Velit qui repellat sunt harum.",
        nucleo_pesquisa: nucleo_pesquisa_by(letra: "A")
      },
      %LinhaPesquisa{
        numero: 2,
        desc: "Debitis culpa ex accusamus sequi?",
        desc_curta: "Aliquam dolores.",
        nucleo_pesquisa: nucleo_pesquisa_by(letra: "B")
      },
      %LinhaPesquisa{
        numero: 3,
        desc: "Aspernatur repudiandae rerum.",
        desc_curta: "Natus commodi provident sint et recusandae!",
        nucleo_pesquisa: nucleo_pesquisa_by(letra: "C")
      },
      %LinhaPesquisa{
        numero: 4,
        desc: "Voluptatem est rerum sit quia aut autem vero esse odit est quam optio quo dolor?",
        desc_curta: "Minus.",
        nucleo_pesquisa: nucleo_pesquisa_by(letra: "D")
      }
    ]
  end
end
