defmodule Pescarte.ModuloPesquisa.Adapters.RelatorioAdapter do
  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.ModuloPesquisa.Models.RelatorioAnualPesquisa, as: Anual
  alias Pescarte.ModuloPesquisa.Models.RelatorioMensalPesquisa, as: Mensal
  alias Pescarte.ModuloPesquisa.Models.RelatorioTrimestralPesquisa, as: Trimestral
  alias Pescarte.ModuloPesquisa.Schemas.RelatorioPesquisa

  @locale Application.compile_env(:pescarte, :locale, "pt_BR")

  @type relatorio :: Anual.t() | Mensal.t() | Trimestral.t()
  @typep changeset :: Ecto.Changeset.t()

  @spec internal_to_external(relatorio) :: {:ok, RelatorioPesquisa.t()} | {:error, changeset}
  def internal_to_external(%{pesquisador: pesquisador} = relatorio) do
    attrs = %{
      id: relatorio.id,
      status: relatorio.status,
      data: relatorio.data_entrega,
      link: relatorio.link,
      tipo: get_relatorio_tipo(relatorio),
      periodo: get_relatorio_periodo!(relatorio),
      nome_pesquisador: Usuario.build_usuario_name(pesquisador.usuario)
    }

    RelatorioPesquisa.parse!(attrs)
  end

  defp get_relatorio_tipo(%RelatorioPesquisa{tipo: "anual"}), do: :anual
  defp get_relatorio_tipo(%RelatorioPesquisa{tipo: "mensal"}), do: :mensal
  defp get_relatorio_tipo(%RelatorioPesquisa{tipo: "trimestral"}), do: :trimestral

  defp get_relatorio_periodo!(relatorio) do
    relatorio.ano
    |> Date.new!(relatorio.mes, 1)
    |> lformat!("{Mfull}/{YYYY}", @locale)
  end
end
