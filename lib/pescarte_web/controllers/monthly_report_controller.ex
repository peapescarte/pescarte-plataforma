defmodule BackendWeb.MonthlyReportController do
  @moduledoc false

  use BackendWeb, :controller

  alias Backend.ResearchModulus
  alias Backend.ResearchModulus.Models.MonthlyReport

  @today Date.utc_today()

  def new(conn, _params) do
    attrs = get_default_attrs()
    changeset = ResearchModulus.change_monthly_report(%MonthlyReport{}, attrs)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"monthly_report" => params}) do
    researcher = conn.assigns.current_user.researcher
    attrs = Map.put(params, :researcher_id, researcher.id)

    case ResearchModulus.create_monthly_report(attrs) do
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
