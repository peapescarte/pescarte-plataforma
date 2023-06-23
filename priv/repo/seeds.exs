defmodule Seeder do
  require Logger
  alias Pescarte.Repo

  @spec append_multi(Ecto.Multi.t(), list(term), binary) :: Ecto.Multi.t()
  def append_multi(multi, entries, key) do
    entries
    |> Enum.with_index()
    |> Enum.reduce(multi, fn {entry, idx}, acc ->
      Ecto.Multi.insert(acc, :"#{key}-#{idx}", entry)
    end)
  end

  def transact(multi) do
    case Pescarte.Repo.transaction(multi) do
      {:ok, _changes} ->
        :ok

      {:error, _, changeset, _} ->
        Logger.error(inspect(changeset))
        :error
    end
  end

  def endereco_seeds do
    Logger.info("==> Executando seeds de Endereco")
    Repo.query!("TRUNCATE TABLE endereco CASCADE")
    [{EnderecoSeed, _}] = Code.require_file("priv/repo/seeds/endereco.exs", ".")

    Ecto.Multi.new()
    |> Seeder.append_multi(EnderecoSeed.entries(), "endereço")
    |> Seeder.transact()
  end

  def campus_seeds do
    Logger.info("==> Executando seeds de Campus")
    Repo.query!("TRUNCATE TABLE campus CASCADE")
    [{CampusSeed, _}] = Code.require_file("priv/repo/seeds/campus.exs", ".")

    Ecto.Multi.new()
    |> Seeder.append_multi(CampusSeed.entries(), "campus")
    |> Seeder.transact()
  end

  def categoria_seeds do
    Logger.info("==> Executando seeds de Categoria")
    Repo.query!("TRUNCATE TABLE categoria CASCADE")
    [{CategoriaSeed, _}] = Code.require_file("priv/repo/seeds/categoria.exs", ".")

    Ecto.Multi.new()
    |> Seeder.append_multi(CategoriaSeed.entries(), "categoria")
    |> Seeder.transact()
  end

  def tag_seeds do
    Logger.info("==> Executando seeds de Tag")
    Repo.query!("TRUNCATE TABLE tag CASCADE")
    [{TagSeed, _}] = Code.require_file("priv/repo/seeds/tag.exs", ".")

    Ecto.Multi.new()
    |> Seeder.append_multi(TagSeed.entries(), "tag")
    |> Seeder.transact()
  end

  def contato_seeds do
    Logger.info("==> Executando seeds de Contato")
    Repo.query!("TRUNCATE TABLE contato CASCADE")
    [{ContatoSeed, _}] = Code.require_file("priv/repo/seeds/contato.exs", ".")

    Ecto.Multi.new()
    |> Seeder.append_multi(ContatoSeed.entries(), "contato")
    |> Seeder.transact()
  end

  def usuario_seeds do
    Logger.info("==> Executando seeds de Usuario")
    Repo.query!("TRUNCATE TABLE usuario CASCADE")
    [{UsuarioSeed, _}] = Code.require_file("priv/repo/seeds/usuario.exs", ".")

    Ecto.Multi.new()
    |> Seeder.append_multi(UsuarioSeed.entries(), "usuario")
    |> Seeder.transact()
  end

  def pesquisador_seeds do
    Logger.info("==> Executando seeds de Pesquisador")
    Repo.query!("TRUNCATE TABLE pesquisador CASCADE")
    [{PesquisadorSeed, _}] = Code.require_file("priv/repo/seeds/pesquisador.exs", ".")

    Ecto.Multi.new()
    |> Seeder.append_multi(PesquisadorSeed.entries(), "pesquisador")
    |> Seeder.transact()
  end

  def midia_seeds do
    Logger.info("==> Executando seeds de Midia")
    Repo.query!("TRUNCATE TABLE midia CASCADE")
    [{MidiaSeed, _}] = Code.require_file("priv/repo/seeds/midia.exs", ".")

    Ecto.Multi.new()
    |> Seeder.append_multi(MidiaSeed.entries(), "midia")
    |> Seeder.transact()
  end
end

# Não mude a ordem de inserção
:ok = Seeder.endereco_seeds()
:ok = Seeder.campus_seeds()
:ok = Seeder.categoria_seeds()
:ok = Seeder.tag_seeds()
:ok = Seeder.contato_seeds()
:ok = Seeder.usuario_seeds()
:ok = Seeder.pesquisador_seeds()
:ok = Seeder.midia_seeds()
