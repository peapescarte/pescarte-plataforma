defmodule ModuloPesquisa.Repository do
  @moduledoc false

  use Database, :repository

  alias ModuloPesquisa.IManageRepository
  alias ModuloPesquisa.Models.Campus
  alias ModuloPesquisa.Models.LinhaPesquisa
  alias ModuloPesquisa.Models.Midia
  alias ModuloPesquisa.Models.Midia.Categoria
  alias ModuloPesquisa.Models.Midia.Tag
  alias ModuloPesquisa.Models.NucleoPesquisa
  alias ModuloPesquisa.Models.Pesquisador
  alias ModuloPesquisa.Models.RelatorioAnualPesquisa
  alias ModuloPesquisa.Models.RelatorioMensalPesquisa
  alias ModuloPesquisa.Models.RelatorioTrimestralPesquisa

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
    Database.fetch(Categoria, id)
  end

  @impl true
  def fetch_categoria_by_id_publico(id) do
    Database.fetch_by(Categoria, id_publico: id)
  end

  @impl true
  def fetch_midia_by_id_publico(id) do
    case Database.fetch_by(Midia, id_publico: id) do
      {:ok, midia} -> {:ok, Repo.replica().preload(midia, :tags)}
      error -> error
    end
  end

  @impl true
  def fetch_tag_by_id_publico(id) do
    Database.fetch_by(Tag, id_publico: id)
  end

  @impl true
  def fetch_tag_by_etiqueta(etiqueta) do
    Database.fetch_by(Tag, etiqueta: etiqueta)
  end

  @impl true
  def fetch_tags_from_ids(tags_ids) do
    query = from t in Tag, where: t.id_publico in ^tags_ids, select: t

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
    with {:ok, tag} <- Database.fetch(Tag, tag_etiqueta) do
      query = from t in Tag, where: t.id == ^tag.id, preload: :midias

      case Database.fetch_one(query) do
        {:error, :not_found} -> []
        {:ok, tag} -> tag.midias
      end
    end
  end

  @impl true
  def list_pesquisador do
    Repo.replica().all(Pesquisador)
  end

  @impl true
  def list_relatorios_pesquisa_from_pesquisador(id) do
    query =
      from p in Pesquisador,
        join: ra in assoc(p, :relatorio_anual),
        join: rm in assoc(p, :relatorios_mensais),
        join: rt in assoc(p, :relatorios_trimestrais),
        where: p.id_publico == ^id,
        select: [ra, rm, rt]

    query
    |> Repo.replica().all()
    |> List.flatten()
    |> Enum.uniq()
  end

  @impl true
  def list_tag do
    Repo.replica().all(Tag)
  end

  @impl true
  def list_tags_from_categoria(categoria_nome) do
    query =
      from c in Categoria,
        where: c.nome == ^categoria_nome,
        preload: :tags

    case Database.fetch_one(query) do
      {:error, :not_found} -> []
      {:ok, categoria} -> categoria.tags
    end
  end

  @impl true
  def list_tags_from_midia(midia_link) do
    query =
      from m in Midia,
        where: m.link == ^midia_link,
        preload: :tags

    case Database.fetch_one(query) do
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
  def upsert_relatorio_anual(rap \\ %RelatorioAnualPesquisa{}, attrs) do
    rap
    |> RelatorioAnualPesquisa.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_relatorio_mensal(rmp \\ %RelatorioMensalPesquisa{}, attrs) do
    rmp
    |> RelatorioMensalPesquisa.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_relatorio_trimestral(rtp \\ %RelatorioTrimestralPesquisa{}, attrs) do
    rtp
    |> RelatorioTrimestralPesquisa.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_tag(tag \\ %Tag{}, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.insert_or_update()
  end
end
