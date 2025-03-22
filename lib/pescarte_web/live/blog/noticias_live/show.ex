defmodule PescarteWeb.Blog.NoticiasLive.Show do
  use PescarteWeb, :live_view

  alias Pescarte.Blog

  @notice_title_max_length Application.compile_env!(:pescarte, [
                             PescarteWeb,
                             :notice_title_max_length
                           ])

  @notice_desc_max_length Application.compile_env!(:pescarte, [
                            PescarteWeb,
                            :notice_desc_max_length
                          ])
  @impl true
  def mount(_params, _session, socket) do
    [first_post, remaining_posts] =
      case Blog.list_posts_with_filter() do
        [] -> [nil, []]
        [head | tail] -> [head, tail]
        {:error, _reason} -> [nil, []]
      end

    socket =
      socket
      |> assign(%{error_message: nil, main_new: first_post, news: remaining_posts})

    {:ok, socket}
  end

  def handle_notice_title_length(text) do
    if String.length(text) > @notice_title_max_length do
      text
      |> truncate_text_until(@notice_title_max_length - 4)
      |> put_ellipsis()
    else
      text
    end
  end

  def handle_notice_desc_length(text) do
    if String.length(text) > @notice_desc_max_length do
      text
      |> truncate_text_until(@notice_desc_max_length - 4)
      |> put_ellipsis()
    else
      text
    end
  end

  defp truncate_text_until(text, length) do
    text
    |> String.slice(0..length)
    |> String.trim_trailing()
  end

  defp put_ellipsis(text) do
    text <> "..."
  end

  def date_to_string(date_time) do
    DateTime.to_date(date_time)
    |> Date.to_string()
    |> String.split("-")
    |> Enum.reverse()
    |> Enum.join("/")
  end

  @impl true
  def handle_event("more_news", _params, socket) do
    current_news_length = socket.assigns.news.length
    loaded_news = Blog.list_posts_with_filter(%{page: current_news_length + 1, page_size: 6})

    socket = socket |> assign(news: socket.assigns.news ++ loaded_news)

    {:noreply, socket}
  end

  @impl true
  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="noticias-grid">
      <.flash :if={@error_message} id="login-error" kind={:error}>
        {@error_message}
      </.flash>
      <div class="phases">
        <div class="noticia-text">
          <.text size="h2" color="text-blue-100">
            Notícias
          </.text>
        </div>
      </div>

      <div class="search-container">
        <input type="text" name="search" id="search" placeholder="Faça uma pesquisa..." />
        <ul class="tags-container">
          <li phx-click={JS.toggle_class("active")}>Tag</li>
          <li phx-click={JS.toggle_class("active")}>Tag</li>
          <li class="active" phx-click={JS.toggle_class("active")}>Tag</li>
          <li phx-click={JS.toggle_class("active")}>Tag</li>
          <li phx-click={JS.toggle_class("active")}>Tag</li>
          <li phx-click={JS.toggle_class("active")}>Tag</li>
          <li phx-click={JS.toggle_class("active")}>Tag</li>
        </ul>
      </div>

      <%= if @main_new do %>
        <div class="main-new">
          <a href={"noticias/#{@main_new.id}"}>
            <.image_from_storage src="noticias/grupos%20focais/capa.webp" />
          </a>
          <div class="main-new-text-container">
            <p class="news-date">{date_to_string(@main_new.inserted_at)}</p>
            <a href={"noticias/#{@main_new.id}"}>
              <h3 class="news-title">
                {@main_new.titulo}
              </h3>
            </a>
            <p class="news-description">
              {handle_notice_desc_length(@main_new.conteudo)}
            </p>
          </div>
        </div>
      <% else %>
        <div class="main-new">
          <p>Nenhuma notícia encontrada</p>
        </div>
      <% end %>

      <div class="landing-grid">
        <div class="news-container">
          <div class="news-cards">
            <%= for new <- @news do %>
              <div class="news-item">
                <a href={"/noticias/#{new.id}"}>
                  <.image_from_storage src="noticias/grupos%20focais/capa.webp" />
                </a>
                <div class="text-container">
                  <p class="news-date">{date_to_string(new.inserted_at)}</p>
                  <a href={"/noticias/#{new.id}"}>
                    <.text size="h4" color="text-blue-100">
                      {handle_notice_title_length(new.titulo)}
                    </.text>
                  </a>
                  <.text size="base" color="text-black-60">
                    {handle_notice_desc_length(new.conteudo)}
                  </.text>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>

      <%= if length(@news) > 0 do %>
        <div phx-click="more_news">
          <.button style="primary">
            <.text size="base" color="text-wite-100">Ver mais...</.text>
          </.button>
        </div>
      <% end %>
      
    <!-- ONDE NOS ENCONTRAR -->
      <PescarteWeb.DesignSystem.GetInTouch.render />
    </div>
    """
  end
end
