defmodule FuschiaWeb.Auth.Pipeline do
  @moduledoc """
  Auth Pipeline for Fuschia app
  """

  use Guardian.Plug.Pipeline, otp_app: :fuschia

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
