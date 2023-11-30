defmodule PescarteWeb.Pesquisa.RelatorioLive.Index do
  use PescarteWeb, :auth_live_view

  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias Pescarte.Database.Repo.Replica, as: Repo
  alias Pescarte.ModuloPesquisa.Models.RelatorioPesquisa
  alias Pescarte.ModuloPesquisa.Repository

  @locale "pt_BR"

  @impl true
  def mount(%{"tipo_relatorio" => report_type}, _session, socket) do
    current_user = Repo.preload(socket.assigns.current_user, :pesquisador)

    {:ok,
     socket
     |> assign(:today, get_formatted_today(Date.utc_today()))
     |> assign(:pesquisador_id, current_user.pesquisador.id_publico)
     |> assign(:report_type, report_type)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:title, "Novo relatório")
    |> assign(:relatorio, %RelatorioPesquisa{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    relatorio = Repository.fetch_relatorio_pesquisa_by_id(id)

    socket
    |> assign(:title, "Editar relatório")
    |> assign(:relatorio, relatorio)
  end

  defp get_formatted_today(%Date{month: month} = today) do
    quarterly = Timex.quarter(today)
    month_word = lformat!(today, "{Mfull}", @locale)
    year = lformat!(today, "{YYYY}", @locale)

    %{year: year, month_word: month_word, month: month, quarterly: quarterly}
  end
end
