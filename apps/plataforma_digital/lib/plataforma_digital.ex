defmodule PlataformaDigital do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use PlataformaDigital, :controller
      use PlataformaDigital, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def static_paths do
    ~w(assets fonts images favicon.ico apple-touch-icon.png favicon-32x32.png favicon-16x16.png safari-pinned-tab.svg browserconfig.xml service_worker.js cache_manifest.json manifest.json android-chrome-192x192.png android-chrome-384x384.png icons)
  end

  @spec controller :: Macro.t()
  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: PlataformaDigital.Layouts]

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  @spec router :: Macro.t()
  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  @spec channel :: Macro.t()
  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {PlataformaDigital.Layouts, :app}

      unquote(html_helpers())
    end
  end

  def auth_live_view do
    quote do
      use Phoenix.LiveView,
        layout: {PlataformaDigital.Layouts, :authenticated}

      on_mount PlataformaDigital.Toast

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      import PlataformaDigital.Toast, only: [put_toast: 3]

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      import Phoenix.HTML.Form, only: [submit: 1, submit: 2]
      import Phoenix.LiveView.TagEngine, only: [component: 3]
      # Core UI components and translation
      import PlataformaDigital.DesignSystem

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS
      alias PlataformaDigital.DesignSystem

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: PlataformaDigital.Endpoint,
        router: PlataformaDigital.Router,
        statics: PlataformaDigital.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
