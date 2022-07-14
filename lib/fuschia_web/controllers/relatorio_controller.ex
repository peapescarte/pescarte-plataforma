defmodule FuschiaWeb.RelatorioController do
  @moduledoc false

  use FuschiaWeb, :controller

  alias Fuschia.ModuloPesquisa
  alias Fuschia.ModuloPesquisa.Models.Relatorio

  @today Date.utc_today()

  def new(conn, _params) do
    attrs = %{mes: @today.month, year: @today.year, tipo: :mensal}
    changeset = ModuloPesquisa.change_relatorio(%Relatorio{}, attrs)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    case ModuloPesquisa.create_relatorio(params) do
      {:ok, _report} ->
        conn
        |> put_flash(:success, "Relatório criado com sucesso")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
