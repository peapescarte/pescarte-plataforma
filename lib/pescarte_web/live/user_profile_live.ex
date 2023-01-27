defmodule PescarteWeb.UserProfileLive do
  use PescarteWeb, :live_view

  on_mount PescarteWeb.UserLiveAuth

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
