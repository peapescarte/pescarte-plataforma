defmodule FuschiaWeb.Router do
  use FuschiaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FuschiaWeb do
    pipe_through :api
  end
end
