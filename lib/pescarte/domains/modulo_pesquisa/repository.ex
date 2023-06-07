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
      multi_id = String.to_existing_atom("tag-#{idx}")

      Ecto.Multi.run(multi, multi_id, fn _, _ ->
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
    Repo.fetch_by(Categoria, id_publico: id)
  end

  @impl true
  def fetch_pesquisador(id) do
    Repo.fetch_by(Pesquisador, id_publico: id)
  end

  @impl true
  def fetch_midia(id) do
    case Repo.fetch_by(Midia, id_publico: id) do
      {:ok, midia} -> {:ok, Repo.preload(midia, :tags)}
      error -> error
    end
  end

  @impl true
  def fetch_tag(id) do
    Repo.fetch_by(Tag, id_publico: id)
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
    query = from t in Tag, where: t.id == ^tag_id, preload: :midias

    case Repo.fetch_one(query) do
      {:error, :not_found} -> []
      {:ok, tag} -> tag.midias
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
        where: c.id == ^categoria_id,
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
    with {:ok, campus} <- Campus.changeset(campus, attrs) do
      Repo.insert(campus)
    end
  end

  @impl true
  def upsert_categoria(categoria \\ %Categoria{}, attrs) do
    with {:ok, categoria} <- Categoria.changeset(categoria, attrs) do
      Repo.insert(categoria)
    end
  end

  @impl true
  def upsert_linha_pesquisa(lp \\ %LinhaPesquisa{}, attrs) do
    with {:ok, linha_pesquisa} <- LinhaPesquisa.changeset(lp, attrs) do
      Repo.insert(linha_pesquisa)
    end
  end

  @impl true
  def upsert_midia(midia \\ %Midia{}, attrs) do
    tags = attrs[:tags] || midia.tags

    with {:ok, midia} <- Midia.changeset(midia, attrs, tags) do
      Repo.insert(midia,
        on_conflict: {:replace_all_except, [:id, :id_publico]},
        conflict_target: [:link]
      )
    end
  end

  @impl true
  def upsert_nucleo_pesquisa(np \\ %NucleoPesquisa{}, attrs) do
    with {:ok, nucleo_pesquisa} <- NucleoPesquisa.changeset(np, attrs) do
      Repo.insert(nucleo_pesquisa)
    end
  end

  @impl true
  def upsert_pesquisador(pesq \\ %Pesquisador{}, attrs) do
    with {:ok, pesquisador} <- Pesquisador.changeset(pesq, attrs) do
      Repo.insert(pesquisador)
    end
  end

  @impl true
  def upsert_relatorio_anual(rap \\ %RelatorioAnual{}, attrs) do
    with {:ok, relatorio_anual} <- RelatorioAnual.changeset(rap, attrs) do
      Repo.insert(relatorio_anual)
    end
  end

  @impl true
  def upsert_relatorio_mensal(rmp \\ %RelatorioMensal{}, attrs) do
    with {:ok, relatorio_mensal} <- RelatorioMensal.changeset(rmp, attrs) do
      Repo.insert(relatorio_mensal)
    end
  end

  @impl true
  def upsert_relatorio_trimestral(rtp \\ %RelatorioTrimestral{}, attrs) do
    with {:ok, relatorio_trimestral} <- RelatorioTrimestral.changeset(rtp, attrs) do
      Repo.insert(relatorio_trimestral)
    end
  end

  @impl true
  def upsert_tag(tag \\ %Tag{}, attrs) do
    with {:ok, tag} <- Tag.changeset(tag, attrs) do
      Repo.insert(tag)
    end
  end
end
