defmodule Mix.Tasks.Seed do
  use Mix.Task

  alias Seeder.Identidades
  alias Seeder.ModuloPesquisa

  @behaviour Seeder

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start", ["--preload-modules"])

    :ok = endereco_seeds()
    :ok = contato_seeds()
    :ok = usuario_seeds()

    :ok = campus_seeds()
    :ok = pesquisador_seeds()
    :ok = categoria_seeds()
    :ok = tag_seeds()
    :ok = midia_seeds()
    :ok = relatorio_pesquisa_seeds()
  end

  @impl Seeder
  def endereco_seeds do
    Seeder.seed(Identidades.Endereco.entries(), "endereco")
  end

  @impl Seeder
  def contato_seeds do
    Seeder.seed(Identidades.Contato.entries(), "contato")
  end

  @impl Seeder
  def usuario_seeds do
    Seeder.seed(Identidades.Usuario.entries(), "usuario")
  end

  @impl Seeder
  def campus_seeds do
    Seeder.seed(ModuloPesquisa.Campus.entries(), "campus")
  end

  @impl Seeder
  def pesquisador_seeds do
    Seeder.seed(ModuloPesquisa.Pesquisador.entries(), "pesquisador")
  end

  @impl Seeder
  def categoria_seeds do
    Seeder.seed(ModuloPesquisa.Categoria.entries(), "categoria")
  end

  @impl Seeder
  def tag_seeds do
    Seeder.seed(ModuloPesquisa.Tag.entries(), "tag")
  end

  @impl Seeder
  def midia_seeds do
    Seeder.seed(ModuloPesquisa.Midia.entries(), "midia")
  end

  @impl Seeder
  def relatorio_pesquisa_seeds do
    Seeder.seed(ModuloPesquisa.RelatorioPesquisa.entries(), "relatorio_pesquisa")
  end
end
