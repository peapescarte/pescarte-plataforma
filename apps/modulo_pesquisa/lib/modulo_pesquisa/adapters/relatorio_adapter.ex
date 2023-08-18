defmodule ModuloPesquisa.Adapters.RelatorioAdapter do
  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias Identidades.Handlers.UsuarioHandler

  alias ModuloPesquisa.Models.RelatorioAnualPesquisa, as: Anual
  alias ModuloPesquisa.Models.RelatorioMensalPesquisa, as: Mensal
  alias ModuloPesquisa.Models.RelatorioTrimestralPesquisa, as: Trimestral
  alias ModuloPesquisa.Schemas.RelatorioPesquisa

  @locale Application.compile_env(:pescarte, :locale, "pt_BR")

  @type relatorio :: Anual.t() | Mensal.t() | Trimestral.t()
  @typep changeset :: Ecto.Changeset.t()

  @spec internal_to_external(relatorio) :: {:ok, RelatorioPesquisa.t()} | {:error, changeset}
  def internal_to_external(%{pesquisador: pesquisador} = relatorio) do
    attrs = %{
      status: relatorio.status,
      data: relatorio.data_entrega,
      tipo: get_relatorio_tipo(relatorio),
      periodo: get_relatorio_periodo!(relatorio),
      nome_pesquisador: UsuarioHandler.build_usuario_name(pesquisador.usuario)
    }

    RelatorioPesquisa.parse!(attrs)
  end

  @doc """
  Parse params to map with atom keys and trimmed values
  """
  @spec parse_params(map) :: map
  def parse_params(params) do
    Enum.reduce(params, %{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), String.trim(v))
    end)
  end

  defp get_relatorio_tipo(%Anual{}), do: :anual
  defp get_relatorio_tipo(%Mensal{}), do: :mensal
  defp get_relatorio_tipo(%Trimestral{}), do: :trimestral

  defp get_relatorio_periodo!(relatorio) do
    relatorio.ano
    |> Date.new!(relatorio.mes, 1)
    |> lformat!("{Mfull}/{YYYY}", @locale)
  end
end
