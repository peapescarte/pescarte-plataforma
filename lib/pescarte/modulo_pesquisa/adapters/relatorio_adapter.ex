defmodule Pescarte.ModuloPesquisa.Adapters.RelatorioAdapter do
  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.ModuloPesquisa.Models.RelatorioPesquisa, as: Model
  alias Pescarte.ModuloPesquisa.Schemas.RelatorioPesquisa, as: Schema

  @locale Application.compile_env(:pescarte, :locale, "pt_BR")

  @spec internal_to_external!(Model.t()) :: Schema.t() | no_return
  def internal_to_external!(%{pesquisador: pesquisador} = relatorio) do
    attrs = %{
      id: relatorio.id,
      status: relatorio.status,
      data: relatorio.data_entrega,
      link: relatorio.link,
      tipo: relatorio.tipo,
      periodo: get_relatorio_periodo!(relatorio),
      nome_pesquisador: Usuario.build_usuario_name(pesquisador.usuario)
    }

    Schema.parse!(attrs)
  end

  defp get_relatorio_periodo!(relatorio) do
    relatorio.ano
    |> Date.new!(relatorio.mes, 1)
    |> lformat!("{Mfull}/{YYYY}", @locale)
  end
end
