defmodule PescarteWeb.Blog.PostLive.Show do
  use PescarteWeb, :live_view

  alias Pescarte.Blog.Post
  alias PescarteWeb.Markdown

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {status, post} = Post.get_post(id)
    {:ok, assign(socket, :post, post)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1><%= @post.titulo %></h1>
      <div><%= raw(Markdown.to_html(@post.conteudo)) %></div>
    </div>
    """
  end
end
