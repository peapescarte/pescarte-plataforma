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
              <th>Meta</th>
              <th>Data</th>
              <th>Horário</th>
              <th>Duração</th>
              <th>Atividade</th>
              <th>Local</th>
              <th>Participantes</th>
            </tr>
          </thead>
          <tbody>
            <%= for %{meta: meta, data: data, horario: horario, duracao: duracao, atividade: atividade, local: local, participantes: participantes} <- assigns do %>
              <tr>
                <td><%= meta %></td>
                <td><%= data %></td>
                <td><%= horario %></td>
                <td><%= duracao %></td>
                <td><%= atividade %></td>
                <td><%= local %></td>
                <td><%= participantes %></td>
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
