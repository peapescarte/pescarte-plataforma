defmodule Pescarte.Domains.ModuloPesquisa.IManageRepository do
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

  @opaque changeset :: Ecto.Changeset.t()

  @callback create_midia_and_tags_multi(map, list(map)) :: {:ok, Midia.t()} | {:error, changeset}

  @callback fetch_categoria(Pescarte.Repo.id()) :: {:ok, Categoria.t()} | {:error, changeset}
  @callback fetch_categoria_by_id_publico(Pescarte.Repo.id()) ::
              {:ok, Categoria.t()} | {:error, changeset}
  @callback fetch_midia_by_id_publico(Pescarte.Repo.id()) ::
              {:ok, Midia.t()} | {:error, changeset}
  @callback fetch_tag(Pescarte.Repo.id()) :: {:ok, Tag.t()} | {:error, changeset}
  @callback fetch_tag_by_etiqueta(binary) :: {:ok, Tag.t()} | {:error, changeset}

  @callback list_categoria :: list(Categoria.t())
  @callback list_midia :: list(Midia.t())
  @callback list_midias_from_tag(Pescarte.Repo.id()) :: list(Midia.t())
  @callback list_pesquisador :: list(Pesquisador.t())
  @callback list_relatorios_pesquisa_from_pesquisador(Pescarte.Repo.id()) :: list(struct)
  @callback list_tag :: list(Tag.t())
  @callback list_tags_from_categoria(Pescarte.Repo.id()) :: list(Tag.t())
  @callback list_tags_from_midia(Pescarte.Repo.id()) :: list(Tag.t())

  @callback upsert_campus(Campus.t(), map) :: {:ok, Campus.t()} | {:error, changeset}
  @callback upsert_categoria(Categoria.t(), map) :: {:ok, Categoria} | {:error, changeset}
  @callback upsert_linha_pesquisa(LinhaPesquisa.t(), map) ::
              {:ok, LinhaPesquisa.t()} | {:error, changeset}
  @callback upsert_midia(Midia.t(), map) :: {:ok, Midia.t()} | {:error, changeset}
  @callback upsert_nucleo_pesquisa(NucleoPesquisa.t(), map) ::
              {:ok, NucleoPesquisa.t()} | {:error, changeset}
  @callback upsert_pesquisador(Pesquisador.t(), map) ::
              {:ok, Pesquisador.t()} | {:error, changeset}
  @callback upsert_relatorio_anual(RelatorioAnual.t(), map) ::
              {:ok, RelatorioAnual.t()} | {:error, changeset}
  @callback upsert_relatorio_mensal(RelatorioMensal.t(), map) ::
              {:ok, RelatorioMensal.t()} | {:error, changeset}
  @callback upsert_relatorio_trimestral(RelatorioTrimestral.t(), map) ::
              {:ok, RelatorioTrimestral.t()} | {:error, changeset}
  @callback upsert_tag(Tag.t(), map) :: {:ok, Tag.t()} | {:error, changeset}
end
