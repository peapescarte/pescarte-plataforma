defmodule FuschiaWeb.FallbackController do
  @moduledoc """
  Handle errors in the FuschiaWeb application
  """

  use FuschiaWeb, :controller

  alias FuschiaWeb.ErrorView

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, %Ecto.Changeset{} = changeset) do
    call(conn, {:error, changeset})
  end

  def call(conn, nil) do
    call(conn, {:error, :not_found})
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("error.json", reason: gettext("The item you requested doesn't exist"))
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("error.json", reason: gettext("Incorrect e-mail or password"))
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> put_view(ErrorView)
    |> render("error.json", reason: gettext("Access Denied"))
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("error.json", reason: reason)
  end

  def call(conn, {:error, :conflict, resource}) do
    conn
    |> put_status(:conflict)
    |> put_view(ErrorView)
    |> render(
      "error.json",
      reason: gettext("The item already exists"),
      resource_id: resource.id
    )
  end
end
