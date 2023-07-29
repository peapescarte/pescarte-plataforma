defmodule Mix.Tasks.Seed do
  use Mix.Task
  alias Seeder.Identidades
  alias Seeder.ModuloPesquisa

  @behaviour Seeder

  # ordem das seeds importa :)
  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start", ["--preload-modules"])

    # identidades
    :ok = endereco_seeds()
    :ok = contato_seeds()
    :ok = usuario_seeds()

    # modulo_pesquisa
    :ok = campus_seeds()
    :ok = pesquisador_seeds()
    :ok = categoria_seeds()
    :ok = tag_seeds()
    :ok = midia_seeds()
    :ok = relatorio_anual_pesquisa_seeds()
    :ok = relatorio_mensal_pesquisa_seeds()
    :ok = relatorio_trimestral_pesquisa_seeds()
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
  def relatorio_anual_pesquisa_seeds do
    Seeder.seed(ModuloPesquisa.RelatorioAnualPesquisa.entries(), "relatorio_anual_pesquisa")
  end

  @impl Seeder
  def relatorio_mensal_pesquisa_seeds do
    Seeder.seed(ModuloPesquisa.RelatorioMensalPesquisa.entries(), "relatorio_mensal_pesquisa")
  end

  @impl Seeder
  def relatorio_trimestral_pesquisa_seeds do
    Seeder.seed(
      ModuloPesquisa.RelatorioTrimestralPesquisa.entries(),
      "relatorio_trimestral_pesquisa"
    )
  end
end
