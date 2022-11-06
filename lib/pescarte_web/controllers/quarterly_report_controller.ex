defmodule PescarteWeb.QuarterlyReportController do
  @moduledoc false

  use PescarteWeb, :controller

  alias Pescarte.ResearchModulus
  alias Pescarte.ResearchModulus.Models.QuarterlyReport

  @today Date.utc_today()

  def new(conn, _params) do
    attrs = get_default_attrs()
    changeset = ResearchModulus.change_quarterly_report(%QuarterlyReport{}, attrs)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"quarterly_report" => params}) do
    researcher = conn.assigns.current_user.researcher
    attrs = Map.put(params, :researcher_id, researcher.id)

    case ResearchModulus.create_quarterly_report(attrs) do
      {:ok, _report} ->
        conn
        |> put_flash(:success, "Relatório criado com sucesso")
        |> redirect(to: Routes.user_profile_path(conn, :edit))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp get_default_attrs do
    %{month: @today.month, year: @today.year}
  end
end
