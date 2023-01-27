defmodule PescarteWeb.RelatorioMensalLive do
  use PescarteWeb, :live_view

  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal

  @today Date.utc_today()

  @full_month %{
    "1" => "Janeiro",
    "2" => "Fevereiro",
    "3" => "Março",
    "4" => "Abril",
    "5" => "Maio",
    "6" => "Junho",
    "7" => "Julho",
    "8" => "Agosto",
    "9" => "Setembro",
    "10" => "Outubro",
    "11" => "Novembro",
    "12" => "Dezembro"
  }

  def mount(_params, _session, socket) do
    pesquisador = socket.assigns.current_user.pesquisador
    attrs = get_default_attrs(pesquisador)
    changeset = ModuloPesquisa.change_relatorio_mensal(%RelatorioMensal{}, attrs)

    {:ok, assign(socket, changeset: changeset)}
  end

  defp get_default_attrs(pesquisador) do
    %{month: @today.month, year: @today.year, pesquisador_id: pesquisador.id}
  end

  defp now_month do
    @today.month
    |> Integer.to_string()
    |> then(&Map.get(@full_month, &1))
  end

  defp now_year do
    @today.year
  end
end
