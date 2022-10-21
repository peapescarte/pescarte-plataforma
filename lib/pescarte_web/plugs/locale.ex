defmodule BackendWeb.LocalePlug do
  @moduledoc """
  Plug to handle gettext locale from request header
  """

  import Plug.Conn

  @default_locale "pt_BR"

  @spec init(map) :: map
  def init(default), do: default

  @spec call(Plug.Conn.t(), map) :: map
  def call(conn, _opts) do
    req_locale =
      conn
      |> get_req_header("accept-language")
      |> List.first()

    locale = req_locale || @default_locale
    Gettext.put_locale(BackendWeb.Gettext, locale)
    conn
  end
end
