defmodule Pescarte.Domains.ModuloPesquisa.Repository do
  # TODO: melhorar documentação
  @moduledoc false

  import Ecto.Changeset, only: [change: 1]
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
  def create_campus(attrs) do
    create_entity(Campus, attrs)
  end

  @impl true
  def create_categoria(attrs) do
    create_entity(Categoria, attrs)
  end

  @impl true
  def create_linha_pesquisa(attrs) do
    create_entity(LinhaPesquisa, attrs)
  end

  @impl true
  def create_midia(attrs) do
    with {:ok, midia} <- Midia.changeset(%Midia{}, attrs) do
      Repo.insert(midia)
    end
  end

  @impl true
  def create_midia_with_tags(attrs, tags) do
    with {:ok, midia} <- Midia.changeset(%Midia{}, attrs, tags) do
      Repo.insert(midia)
    end
  end

  @impl true
  def create_midia_and_tags_multi(attrs, tags_attrs) do
    tags_attrs
    |> Enum.with_index()
    |> Enum.reduce(Ecto.Multi.new(), fn {attrs, idx}, multi ->
      Ecto.Multi.run(multi, :"tag-#{idx}", fn _, _ ->
        create_tag(attrs)
      end)
    end)
    |> Ecto.Multi.run(:tags, fn _repo, _changes ->
      {:ok, list_tag()}
    end)
    |> Ecto.Multi.insert(:midia, fn %{tags: tags} ->
      Midia.changeset(%Midia{}, attrs, tags)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{midia: midia}} -> {:ok, midia}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  @impl true
  def create_nucleo_pesquisa(attrs) do
    create_entity(NucleoPesquisa, attrs)
  end

  @impl true
  def create_pesquisador(attrs) do
    create_entity(Pesquisador, attrs)
  end

  @impl true
  def create_relatorio_anual(attrs) do
    create_entity(RelatorioAnual, attrs)
  end

  @impl true
  def create_relatorio_mensal(attrs) do
    create_entity(RelatorioMensal, attrs)
  end

  @impl true
  def create_relatorio_trimestral(attrs) do
    create_entity(RelatorioTrimestral, attrs)
  end

  @impl true
  def create_tag(attrs) do
    create_entity(Tag, attrs)
  end

  defp create_entity(entity, attrs) do
    with {:ok, entity} <- entity.changeset(attrs) do
      Repo.insert(entity)
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
    Repo.fetch_by(Midia, id_publico: id)
  end

  @impl true
  def update_midia(%Midia{} = midia, attrs) do
    midia = Repo.preload(midia, :tags)

    with {:ok, midia} <- Midia.changeset(midia, attrs, midia.tags) do
      midia
      |> change()
      |> Repo.update()
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
  def update_midia_with_tags(%Midia{} = midia, attrs, tags) do
    midia = Repo.preload(midia, :tags)
    tags = midia.tags ++ tags

    with {:ok, midia} <- Midia.changeset(midia, attrs, tags) do
      midia
      |> change()
      |> Repo.update()
    end
  end

  @impl true
  def update_pesquisador(%Pesquisador{} = pesquisador, attrs) do
    update_entity(Pesquisador, pesquisador, attrs)
  end

  @impl true
  def update_tag(%Tag{} = tag, attrs) do
    update_entity(Tag, tag, attrs)
  end

  defp update_entity(entity, current, attrs) do
    with {:ok, entity} <- entity.changeset(current, attrs) do
      entity
      |> change()
      |> Repo.update()
    end
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
  def list_relatorios_pesquisa do
    Repo.all(RelatorioAnual) ++ Repo.all(RelatorioMensal) ++ Repo.all(RelatorioTrimestral)
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
end
