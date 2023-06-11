defmodule Pescarte.Domains.ModuloPesquisa.Repository do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias Pescarte.Domains.ModuloPesquisa.IManageRepository
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus
  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioAnual
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioTrimestral
  alias Pescarte.Repo

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
    Repo.fetch(Categoria, id)
  end

  @impl true
  def fetch_categoria_by_id_publico(id) do
    Repo.fetch_by(Categoria, id_publico: id)
  end

  @impl true
  def fetch_midia_by_id_publico(id) do
    case Repo.fetch_by(Midia, id_publico: id) do
      {:ok, midia} -> {:ok, Repo.preload(midia, :tags)}
      error -> error
    end
  end

  @impl true
  def fetch_tag(id) do
    Repo.fetch(Tag, id)
  end

  @impl true
  def fetch_tag_by_etiqueta(etiqueta) do
    Repo.fetch_by(Tag, etiqueta: etiqueta)
  end

  @impl true
  def list_categoria do
    Repo.all(Categoria)
  end

  @impl true
  def list_midia do
    Repo.all(Midia)
  end

  @impl true
  def list_midias_from_tag(tag_id) do
    with {:ok, tag} <- Repo.fetch_by(Tag, id_publico: tag_id) do
      query = from t in Tag, where: t.id == ^tag.id, preload: :midias

      case Repo.fetch_one(query) do
        {:error, :not_found} -> []
        {:ok, tag} -> tag.midias
      end
    end
  end

  @impl true
  def list_pesquisador do
    Repo.all(Pesquisador)
  end

  @impl true
  def list_relatorios_pesquisa_from_pesquisador(id) do
    query =
      from p in Pesquisador,
        join: ra in assoc(p, :relatorio_anual),
        join: rm in assoc(p, :relatorios_mensais),
        join: rt in assoc(p, :relatorios_trimestrais),
        where: p.id == ^id,
        select: [ra, rm, rt]

    query
    |> Repo.all()
    |> List.flatten()
    |> Enum.uniq()
  end

  @impl true
  def list_tag do
    Repo.all(Tag)
  end

  @impl true
  def list_tags_from_categoria(categoria_id) do
    query =
      from c in Categoria,
        where: c.id_publico == ^categoria_id,
        preload: :tags

    case Repo.fetch_one(query) do
      {:error, :not_found} -> []
      {:ok, categoria} -> categoria.tags
    end
  end

  @impl true
  def list_tags_from_midia(midia_id) do
    query =
      from m in Midia,
        where: m.id_publico == ^midia_id,
        preload: :tags

    case Repo.fetch_one(query) do
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
  def upsert_relatorio_anual(rap \\ %RelatorioAnual{}, attrs) do
    rap
    |> RelatorioAnual.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_relatorio_mensal(rmp \\ %RelatorioMensal{}, attrs) do
    rmp
    |> RelatorioMensal.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_relatorio_trimestral(rtp \\ %RelatorioTrimestral{}, attrs) do
    rtp
    |> RelatorioTrimestral.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_tag(tag \\ %Tag{}, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.insert_or_update()
  end
end
