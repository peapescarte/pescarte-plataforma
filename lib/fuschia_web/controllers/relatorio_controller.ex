defmodule FuschiaWeb.RelatorioController do
  @moduledoc false

  use FuschiaWeb, :controller

  alias Fuschia.ModuloPesquisa
  alias Fuschia.ModuloPesquisa.Models.Relatorio

  @today Date.utc_today()

  def new(conn, _params) do
    attrs = get_default_attrs()
    changeset = ModuloPesquisa.change_relatorio(%Relatorio{}, attrs)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"relatorio" => params}) do
    user = conn.assigns.current_user
    attrs = build_report_attrs(user, params)

    case ModuloPesquisa.create_relatorio(attrs) do
      {:ok, _report} ->
        conn
        |> put_flash(:success, "Relatório criado com sucesso")
        |> redirect(to: Routes.user_profile_path(conn, :edit))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp build_report_attrs(user, params) do
    raw_content =
      Enum.reduce(params, <<>>, fn
        {_k, editor}, acc -> acc <> editor <> "\n"
      end)

    get_default_attrs()
    |> Map.put(:raw_content, raw_content)
    |> Map.put(:pesquisador_cpf, user.cpf)
  end

  defp get_default_attrs do
    %{mes: @today.month, ano: @today.year, tipo: "mensal"}
  end
end
