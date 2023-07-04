defmodule ModuloPesquisa.IManageRepository do
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

  @opaque changeset :: Ecto.Changeset.t()

  @callback create_midia_and_tags_multi(map, list(map)) :: {:ok, Midia.t()} | {:error, changeset}

  @callback fetch_categoria(Database.id()) :: {:ok, Categoria.t()} | {:error, changeset}
  @callback fetch_categoria_by_id_publico(Database.id()) ::
              {:ok, Categoria.t()} | {:error, changeset}
  @callback fetch_midia_by_id_publico(Database.id()) ::
              {:ok, Midia.t()} | {:error, changeset}
  @callback fetch_tag_by_id_publico(Database.id()) :: {:ok, Tag.t()} | {:error, changeset}
  @callback fetch_tag_by_etiqueta(binary) :: {:ok, Tag.t()} | {:error, changeset}
  @callback fetch_tags_from_ids(list(Database.id())) :: list(Tag.t())

  @callback list_categoria :: list(Categoria.t())
  @callback list_midia :: list(Midia.t())
  @callback list_midias_from_tag(Database.id()) :: list(Midia.t())
  @callback list_pesquisador :: list(Pesquisador.t())
  @callback list_relatorios_pesquisa_from_pesquisador(Database.id()) :: list(struct)
  @callback list_tag :: list(Tag.t())
  @callback list_tags_from_categoria(Database.id()) :: list(Tag.t())
  @callback list_tags_from_midia(Database.id()) :: list(Tag.t())

  @callback upsert_campus(Campus.t(), map) :: {:ok, Campus.t()} | {:error, changeset}
  @callback upsert_categoria(Categoria.t(), map) :: {:ok, Categoria} | {:error, changeset}
  @callback upsert_linha_pesquisa(LinhaPesquisa.t(), map) ::
              {:ok, LinhaPesquisa.t()} | {:error, changeset}
  @callback upsert_midia(Midia.t(), map) :: {:ok, Midia.t()} | {:error, changeset}
  @callback upsert_nucleo_pesquisa(NucleoPesquisa.t(), map) ::
              {:ok, NucleoPesquisa.t()} | {:error, changeset}
  @callback upsert_pesquisador(Pesquisador.t(), map) ::
              {:ok, Pesquisador.t()} | {:error, changeset}
  @callback upsert_relatorio_anual(RelatorioAnualPesquisa.t(), map) ::
              {:ok, RelatorioAnualPesquisa.t()} | {:error, changeset}
  @callback upsert_relatorio_mensal(RelatorioMensalPesquisa.t(), map) ::
              {:ok, RelatorioMensalPesquisa.t()} | {:error, changeset}
  @callback upsert_relatorio_trimestral(RelatorioTrimestralPesquisa.t(), map) ::
              {:ok, RelatorioTrimestralPesquisa.t()} | {:error, changeset}
  @callback upsert_tag(Tag.t(), map) :: {:ok, Tag.t()} | {:error, changeset}
end
