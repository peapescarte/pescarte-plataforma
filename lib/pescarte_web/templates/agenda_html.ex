defmodule PescarteWeb.AgendaHTML do
  use PescarteWeb, :html

  embed_templates("agenda_html/*")

  def table_render(assigns) do
    ~H"""
    <div class="container mx-auto mt-8 mb-8">
      <div class="table-container">
        <table class="min-w-full">
          <thead>
            <tr>
              <th>Data</th>
              <th>Horário</th>
              <th>Atividade</th>
              <th>Local</th>
            </tr>
          </thead>
          <tbody>
            <%= for %{data: data, horario: horario, atividade: atividade, local: local} <- assigns do %>
              <tr>
                <td>{data}</td>
                <td>{horario}</td>
                <td class="table-lg">{atividade}</td>
                <td class="table-lg">{local}</td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  def handle_event("dialog", _value, socket) do
    IO.puts("HII")

    {:noreply, socket}
  end
end
