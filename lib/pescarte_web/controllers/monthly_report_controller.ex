defmodule PescarteWeb.RelatorioMensalController do
  @moduledoc false

  use PescarteWeb, :controller

  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal

  @today Date.utc_today()

  def new(conn, _params) do
    attrs = get_default_attrs()
    changeset = ModuloPesquisa.change_relatorio_mensal(%RelatorioMensal{}, attrs)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"relatorio_mensal" => params}) do
    pesquisador = conn.assigns.current_user.pesquisador
    attrs = Map.put(params, :pesquisador_id, pesquisador.id)

    case ModuloPesquisa.create_relatorio_mensal(attrs) do
      {:ok, _report} ->
        conn
        |> put_flash(:success, "Relatório criado com sucesso")
        |> redirect(to: ~p"/app/perfil")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp get_default_attrs do
    %{month: @today.month, year: @today.year}
  end
end
