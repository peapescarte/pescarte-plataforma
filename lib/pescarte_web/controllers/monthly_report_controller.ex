defmodule PescarteWeb.MonthlyReportController do
  @moduledoc false

  use PescarteWeb, :controller

  alias Pescarte.ResearchModulus
  alias Pescarte.ResearchModulus.Models.MonthlyReport

  @today Date.utc_today()

  # Helper - repetido em cada controller, onde unificar?
  def key_to_atom(map) do
    Enum.reduce(map, %{}, fn
      {key, value}, acc when is_atom(key) -> Map.put(acc, key, value)
      {key, value}, acc when is_binary(key) -> Map.put(acc, String.to_existing_atom(key), value)
    end)
  end

  def new(conn, _params) do
    attrs = get_default_attrs()
    changeset = ResearchModulus.change_monthly_report(%MonthlyReport{}, attrs)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"monthly_report" => params}) do
    researcher = conn.assigns.current_user.researcher
    # params = params
    # |> key_to_atom

    attrs = Map.put(params, "researcher_id", researcher.id)
    |> Map.put("year", @today.year)
    |> Map.put("month", @today.month)
    |> Map.put("status", "em_edicao")
    |> IO.inspect

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
