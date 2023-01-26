defmodule PescarteWeb.RelatorioMensalController do
  @moduledoc false

  use PescarteWeb, :controller

  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal

  @today Date.utc_today()

  def new(conn, _params) do
    pesquisador = conn.assigns.current_user.pesquisador
    attrs = get_default_attrs(pesquisador)
    changeset = ModuloPesquisa.change_relatorio_mensal(%RelatorioMensal{}, attrs)

    render(conn, :new, changeset: changeset)
  end

  def save(conn, %{"relatorio_mensal" => params}) do
    IO.inspect(params, label: "SAVE")
  end

  def create(conn, %{"relatorio_mensal" => params}) do
    case ModuloPesquisa.create_relatorio_mensal(params) do
      {:ok, _report} ->
        conn
        |> put_flash(:success, "Relatório criado com sucesso")
        |> redirect(to: ~p"/app/perfil")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  defp get_default_attrs(pesquisador) do
    %{month: @today.month, year: @today.year, pesquisador_id: pesquisador.id}
  end
end
