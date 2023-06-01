defmodule Pescarte.Domains.ModuloPesquisa.IManageModuloPesquisa do
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus
  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioAnual
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioTrimestral

  @opaque changeset :: Ecto.Changeset.t()

  @callback create_campus(map) :: {:ok, Campus.t()} | {:error, changeset}
  @callback create_categoria(map) :: {:ok, Categoria} | {:error, changeset}
  @callback create_linha_pesquisa(map) :: {:ok, LinhaPesquisa.t()} | {:error, changeset}
  @callback create_midia(map) :: {:ok, Midia.t()} | {:error, changeset}
  @callback create_midia_with_tags(map, list(Tag.t())) :: {:ok, Midia.t()} | {:error, changeset}
  @callback create_nucleo_pesquisa(map) :: {:ok, NucleoPesquisa.t()} | {:error, changeset}
  @callback create_pesquisador(map) :: {:ok, Pesquisador.t()} | {:error, changeset}
  @callback create_relatorio_anual(map) :: {:ok, RelatorioAnual.t()} | {:error, changeset}
  @callback create_relatorio_mensal(map) :: {:ok, RelatorioMensal.t()} | {:error, changeset}
  @callback create_relatorio_trimestral(map) ::
              {:ok, RelatorioTrimestral.t()} | {:error, changeset}
  @callback create_tag(map) :: {:ok, Tag.t()} | {:error, changeset}

  @callback fetch_pesquisador(Pescarte.Repo.id()) :: {:ok, Pesquisador.t()} | {:error, changeset}
  @callback fetch_midia(Pescarte.Repo.id()) :: {:ok, Midia.t()} | {:error, changeset}

  @callback update_midia(Midia.t(), map) :: {:ok, Midia.t()} | {:error, changeset}
  @callback update_midia_with_tags(Midia.t(), map, list(Tag.t())) ::
              {:ok, Midia.t()} | {:error, changeset}
  @callback update_pesquisador(Pesquisador.t(), map) ::
              {:ok, Pesquisador.t()} | {:error, changeset}
  @callback update_tag(Tag.t(), map) :: {:ok, Tag.t()} | {:error, changeset}

  @callback list_categoria :: list(Categoria.t())
  @callback list_pesquisador :: list(Pesquisador.t())
  @callback list_relatorios_pesquisa :: list(struct)
  @callback list_relatorios_pesquisa_from_pesquisador(Pescarte.Repo.id()) :: list(struct)
  @callback list_tags_from_midia(Pescarte.Repo.id()) :: list(Tag.t())
end
