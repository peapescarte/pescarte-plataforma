defmodule PescarteWeb.Blog.PostLive.Show do
  use PescarteWeb, :live_view

  alias Pescarte.Blog.Post
  alias PescarteWeb.Markdown

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    case Post.get_post(id) do
      {:ok, post} -> {:ok, assign(socket, post: post)}
      _ -> {:ok, push_navigate(socket, to: "/noticias")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="noticia">
      <h1 class="text-4xl leading-10 font-bold text-blue-100"><%= @post.titulo %></h1>
      <div class="noticia-descricao"><%= raw(Markdown.to_html(@post.conteudo)) %></div>
      <DesignSystem.link href="/noticias" class="text-sm font-semibold">
        <.button style="primary">
          <Lucideicons.arrow_left class="text-white-100" /> Voltar para Notícias
        </.button>
      </DesignSystem.link>
    </div>
    <PescarteWeb.DesignSystem.GetInTouch.render />
    """
  end
end
