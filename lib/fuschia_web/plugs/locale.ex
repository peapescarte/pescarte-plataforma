defmodule FuschiaWeb.LocalePlug do
  @moduledoc """
  Plug to handle gettext locale from request header
  """

  import Plug.Conn

  @default_locale "en"

  def init(default), do: default

  def call(conn, _opts) do
    req_locale =
      get_req_header(conn, "accept-language")
      |> List.first()

    locale = req_locale || @default_locale
    Gettext.put_locale(FuschiaWeb.Gettext, locale)
    conn
  end
end
