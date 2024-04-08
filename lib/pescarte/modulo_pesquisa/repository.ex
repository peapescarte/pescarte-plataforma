defmodule Pescarte.ModuloPesquisa.Repository do
  @moduledoc false

  use Pescarte, :repository

  import Ecto.Query

  alias Pescarte.Database
  alias Pescarte.ModuloPesquisa.IManageRepository
  alias Pescarte.ModuloPesquisa.Models.Campus
  alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.ModuloPesquisa.Models.Midia
  alias Pescarte.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.ModuloPesquisa.Models.RelatorioPesquisa

  @behaviour IManageRepository

  @impl true
  def create_midia_and_tags_multi(attrs, tags_attrs) do
    tags_attrs
    |> Enum.with_index()
    |> Enum.reduce(Ecto.Multi.new(), fn {attrs, idx}, multi ->
      Ecto.Multi.run(multi, :"tag-#{idx}", fn _, _ ->
        upsert_tag(attrs)
      end)
    end)
    |> Ecto.Multi.run(:midia, fn _repo, tags ->
      tags = Map.values(tags)

      attrs
      |> Map.put(:tags, tags)
      |> upsert_midia()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{midia: midia}} -> {:ok, midia}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  @impl true
  def fetch_categoria(id) do
    Pescarte.Database.fetch(Categoria, id)
  end

  @impl true
  def fetch_midia(id) do
    case Pescarte.Database.fetch_by(Midia, id: id) do
      {:ok, midia} -> {:ok, Repo.replica().preload(midia, :tags)}
      error -> error
    end
  end

  @impl true
  def fetch_tag(id) do
    Pescarte.Database.fetch_by(Tag, id: id)
  end

  @impl true
  def fetch_tag_by_etiqueta(etiqueta) do
    Pescarte.Database.fetch_by(Tag, etiqueta: etiqueta)
  end

  @impl true
  def fetch_tags_from_ids(tags_ids) do
    query = from(t in Tag, where: t.id in ^tags_ids, select: t)

    Repo.replica().all(query)
  end

  @impl true
  def list_categoria do
    Repo.replica().all(Categoria)
  end

  @impl true
  def list_midia do
    Repo.replica().all(Midia)
  end

  @impl true
  def list_midias_from_tag(tag_etiqueta) do
    with {:ok, tag} <- Pescarte.Database.fetch(Tag, tag_etiqueta) do
      query = from(t in Tag, where: t.id == ^tag.id, preload: :midias)

      case Pescarte.Database.fetch_one(query) do
        {:error, :not_found} -> []
        {:ok, tag} -> tag.midias
      end
    end
  end

  @impl true
  def list_pesquisador do
    query = from(p in Pesquisador, preload: [usuario: [:contato]])

    Repo.replica().all(query)
  end

  @impl true
  def list_relatorios_pesquisa do
    relatorios = from(rp in RelatorioPesquisa, preload: [pesquisador: :usuario])

    Repo.replica().all(relatorios)
  end

  @impl true
  def list_relatorios_pesquisa_from_pesquisador(id) do
    query =
      from(p in Pesquisador,
        where: p.id == ^id,
        preload: [
          relatorios_pesquisa: [pesquisador: :usuario]
        ]
      )

    query
    |> Repo.replica().all()
    |> Enum.map(&[&1.relatorios_pesquisa])
    |> List.flatten()
    |> Enum.uniq()
  end

  @impl true
  def fetch_relatorio_pesquisa_by_id(id) do
    query =
      from r in RelatorioPesquisa,
        where: r.id == ^id,
        preload: [pesquisador: [:usuario, :linha_pesquisa, :orientador]]

    Database.fetch_one(query)
  end

  def fetch_relatorio_pesquisa_by_id_and_kind(id, kind) do
    query =
      from r in RelatorioPesquisa,
        where: r.id == ^id,
        where: r.tipo == ^kind,
        preload: [pesquisador: [:usuario, :linha_pesquisa, :orientador]]

    Database.fetch_one(query)
  end

  @impl true
  def list_tag do
    Repo.replica().all(Tag)
  end

  @impl true
  def list_tags_from_categoria(categoria_nome) do
    query =
      from(c in Categoria,
        where: c.nome == ^categoria_nome,
        preload: :tags
      )

    case Pescarte.Database.fetch_one(query) do
      {:error, :not_found} -> []
      {:ok, categoria} -> categoria.tags
    end
  end

  @impl true
  def list_tags_from_midia(midia_link) do
    query =
      from(m in Midia,
        where: m.link == ^midia_link,
        preload: :tags
      )

    case Pescarte.Database.fetch_one(query) do
      {:error, :not_found} -> []
      {:ok, midia} -> midia.tags
    end
  end

  @impl true
  def upsert_campus(campus \\ %Campus{}, attrs) do
    campus
    |> Campus.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_categoria(categoria \\ %Categoria{}, attrs) do
    categoria
    |> Categoria.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_linha_pesquisa(lp \\ %LinhaPesquisa{}, attrs) do
    lp
    |> LinhaPesquisa.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_midia(midia \\ %Midia{}, attrs) do
    tags = attrs[:tags] || midia.tags

    midia
    |> Midia.changeset(attrs, tags)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_nucleo_pesquisa(np \\ %NucleoPesquisa{}, attrs) do
    np
    |> NucleoPesquisa.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_pesquisador(pesq \\ %Pesquisador{}, attrs) do
    pesq
    |> Pesquisador.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_relatorio_pesquisa(rp \\ %RelatorioPesquisa{}, attrs) do
    rp
    |> RelatorioPesquisa.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_tag(tag \\ %Tag{}, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.insert_or_update()
  end
end
