defmodule PescarteWeb.NavbarLive do
  use PescarteWeb, :auth_live_view

  def on_mount(:default, _params, _session, socket) do
    socket =
      assign(socket,
        menus: [
          {"Home", ~p"/app/pesquisa/perfil", :home},
          {"Pesquisadores", ~p"/app/pesquisa/pesquisadores", :users},
          {"Relatórios", ~p"/app/pesquisa/relatorios", :file_text},
          {"Agenda", ~p"/", :calendar_days},
          {"Mensagens", ~p"/", :mail}
        ]
      )

    {:cont, attach_hook(socket, :set_menu_path, :handle_params, &manage_active_tabs/3)}
  end

  defp manage_active_tabs(_params, url, socket) do
    {:cont, assign(socket, current_path: URI.parse(url).path)}
  end
end
