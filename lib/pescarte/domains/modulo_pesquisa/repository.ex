defmodule Pescarte.Domains.ModuloPesquisa.Repository do
  use Pescarte, :repository

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioTrimestral
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioAnual
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal
  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus

  @type changeset :: Ecto.Changeset.t()

  @doc """
  Busca um `%Campus{}` específico pelo `:id_publico` ou `:nome`.
  """
  @spec get_campus(keyword) :: nil
  def get_campus(params), do: nil

  @doc """
  Cria um registro de `%Campus{}` no banco de dados.
  """
  @spec insert_campus(map) :: {:ok, Campus.t()} | {:error, changeset}
  def insert_campus(attrs) do
    attrs
    |> Campus.changeset()
    |> Repo.insert()
  end

  @doc """
  Cria um registro de `%Categoria{}` no banco de dados.
  """
  @spec insert_categoria(map) :: {:ok, Categoria.t()} | {:error, changeset}
  def insert_categoria(attrs) do
    attrs
    |> Categoria.changeset()
    |> Repo.insert()
  end

  @doc """
  Cria um registro de `%LinhaPesquisa{}` no banco de dados.
  """
  @spec insert_linha_pesquisa(map) :: {:ok, LinhaPesquisa.t()} | {:error, changeset}
  def insert_linha_pesquisa(attrs) do
    attrs |> LinhaPesquisa.changeset() |> Repo.insert()
  end

  @doc """
  Cria um registro de `%Midia{}` no banco de dados.
  """
  @spec insert_midia(map) :: {:ok, Midia.t()} | {:error, changeset}
  def insert_midia(attrs) do
    tags = Map.get(attrs, :tags, [])
    attrs |> Midia.changeset(tags) |> Repo.insert()
  end

  @doc """
  Cria um registro de `%NucleoPesquisa{}` no banco de dados.
  """
  @spec insert_nucleo_pesquisa(map) :: {:ok, NucleoPesquisa.t()} | {:error, changeset}
  def insert_nucleo_pesquisa(attrs) do
    attrs |> NucleoPesquisa.changeset() |> Repo.insert()
  end

  @doc """
  Cria um registro de `%RelatorioAnual{}` no banco de dados.
  """
  @spec insert_relatorio_anual(map) :: {:ok, RelatorioAnual.t()} | {:error, changeset}
  def insert_relatorio_anual(attrs) do
    attrs |> RelatorioAnual.changeset() |> Repo.insert()
  end

  @doc """
  Cria um registro de `%RelatorioMensal{}` no banco de dados.
  """
  @spec insert_relatorio_mensal(map) :: {:ok, RelatorioMensal.t()} | {:error, changeset}
  def insert_relatorio_mensal(attrs) do
    attrs |> RelatorioMensal.changeset() |> Repo.insert()
  end

  @doc """
  Cria um registro de `%RelatorioTrimestral{}` no banco de dados.
  """
  @spec insert_relatorio_trimestral(map) :: {:ok, RelatorioTrimestral.t()} | {:error, changeset}
  def insert_relatorio_trimestral(attrs) do
    attrs |> RelatorioTrimestral.changeset() |> Repo.insert()
  end

  @doc """
  Cria um registro de `%Tag{}` no banco de dados.
  """
  @spec insert_tag(map) :: {:ok, Tag.t()} | {:error, changeset}
  def insert_tag(attrs) do
    attrs |> Tag.changeset() |> Repo.insert()
  end
end
