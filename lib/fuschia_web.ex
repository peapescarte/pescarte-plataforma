defmodule FuschiaWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use FuschiaWeb, :controller
      use FuschiaWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  import Phoenix.Controller, only: [put_view: 2, render: 3]
  import Plug.Conn, only: [put_status: 2]

  alias FuschiaWeb.FuschiaView

  @spec controller :: Macro.t()
  def controller do
    quote do
      use Phoenix.Controller, namespace: FuschiaWeb

      import Plug.Conn
      import FuschiaWeb.Gettext
      import FuschiaWeb, only: [render_response: 2, render_response: 3]
      alias FuschiaWeb.Router.Helpers, as: Routes
    end
  end

  @spec surface_view :: Macro.t()
  def surface_view do
    quote do
      use Surface.LiveView,
        layout: {FuschiaWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  @spec view :: Macro.t()
  def view do
    quote do
      use Phoenix.View,
        root: "lib/fuschia_web/templates",
        namespace: FuschiaWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
      import Surface
    end
  end

  @spec live_view :: Macro.t()
  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {FuschiaWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  @spec live_component :: Macro.t()
  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  @spec component :: Macro.t()
  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  @spec router :: Macro.t()
  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  @spec channel :: Macro.t()
  def channel do
    quote do
      use Phoenix.Channel
      import FuschiaWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      use Phoenix.HTML

      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import FuschiaWeb.ErrorHelpers
      import FuschiaWeb.Gettext
      alias FuschiaWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  Get current timestamp
  """
  @spec timestamp :: String.t()
  def timestamp do
    Timex.format!(Timex.now(), "%Y-%m-%dT%H:%M:%SZ", :strftime)
  end

  @doc """
  Return default socket response format

  {
    "data": {},
    "timestamp": "2021-02-01T11:48:52Z"
  }
  """
  @spec socket_response(map) :: map
  def socket_response(payload) do
    %{
      data: payload,
      timestamp: timestamp()
    }
  end

  @doc """
  Render success response with data in body or nil if `data` is nil,
  so the fallback controller can render the proper response.

  Render the paginated view if the `pagination` param is present.
  """
  @spec render_response(nil, Plug.Conn.t()) :: nil
  def render_response(nil, _conn), do: nil

  @spec render_response(map, Plug.Conn.t()) :: Plug.Conn.t()
  def render_response(%{data: data, pagination: pagination}, conn) do
    conn
    |> put_status(:ok)
    |> put_view(FuschiaView)
    |> render("paginated.json", %{data: data, pagination: pagination})
  end

  @spec render_response(map | list, Plug.Conn.t()) :: Plug.Conn.t()
  def render_response(data, conn) do
    conn
    |> put_status(:ok)
    |> put_view(FuschiaView)
    |> render("response.json", data: data)
  end

  @doc """
  Render response with status and data in body
  """
  @spec render_response(map | list, Plug.Conn.t(), atom) :: Plug.Conn.t()
  def render_response(data, conn, status) do
    conn
    |> put_status(status)
    |> put_view(FuschiaView)
    |> render("response.json", data: data)
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
