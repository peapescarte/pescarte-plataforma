defmodule Mix.Tasks.Seeds do
  use Mix.Task

  def run(_) do
    Mix.Task.run("app.start", [])
    Seeds.Cidades.run()
    Seeds.Campi.run()
    Seeds.Users.run()
    Seeds.Pesquisadores.run()
    Seeds.Categorias.run()
    Seeds.Tags.run()
    Seeds.Midias.run()
  end
end
