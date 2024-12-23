defmodule PescarteWeb.Pesquisa.RelatorioController do
  use PescarteWeb, :controller

  import Phoenix.LiveView.Controller, only: [live_render: 3]

  alias Pescarte.RelatorioCompiler
  alias PescarteWeb.Pesquisa.RelatorioLive

  require Logger

  def download_pdf(conn, %{"id" => id}) do
    case RelatorioCompiler.gerar_pdf(id) do
      {:ok, pdf_filename, pdf_binary} ->
        conn
        |> put_status(:ok)
        |> send_download({:binary, pdf_binary}, filename: pdf_filename)
        |> live_render(RelatorioLive.Index,
          session: %{
            "current_user" => get_session(conn, :current_user),
            "current_usuario" => get_session(conn, :current_usuario)
          }
        )

      {:error, reason} ->
        Logger.error("failed with #{inspect(reason, pretty: true)}")
        conn |> put_status(:internal_error) |> send_resp()
    end
  end

  def compilar_relatorios(conn, %{"relatorio_compile" => params}) do
    relatorios_selecionados = parse_relatorios_ids(params)

    case RelatorioCompiler.compilar_relatorios(
           relatorios_selecionados,
           &send_relatorios_compiled(&1, conn)
         ) do
      {:ok, {:error, reason}} ->
        Logger.error("failed with #{inspect(reason, pretty: true)}")
        send_resp(conn, :internal_error, "")

      {:ok, {:ok, conn}} ->
        conn

      {:error, reason} ->
        Logger.error("failed with #{inspect(reason, pretty: true)}")
        send_resp(conn, :internal_error, "")
    end
  end

  defp send_relatorios_compiled(zip_path, conn) do
    conn
    |> put_status(:ok)
    |> send_download({:file, to_string(zip_path)})
    |> live_render(RelatorioLive.Index,
      session: %{
        "current_user" => get_session(conn, :current_user),
        "current_usuario" => get_session(conn, :current_usuario)
      }
    )
  end

  defp parse_relatorios_ids(params) do
    params
    |> Map.filter(fn {_, val} -> val == "on" end)
    |> Enum.map(fn {key, _} -> key |> String.split("_", trim: true) |> Enum.at(1) end)
  end
end
