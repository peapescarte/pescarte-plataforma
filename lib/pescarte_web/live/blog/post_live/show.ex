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
    <div>
      <h1><%= @post.titulo %></h1>
      <div><%= raw(Markdown.to_html(@post.conteudo)) %></div>
    </div>
    """
  end
end
