defmodule PescarteWeb.NoticiasController do
  use PescarteWeb, :controller
  alias Pescarte.Blog

  def show(conn, _params) do
    current_path = conn.request_path

    [first_post, remaining_posts] =
      case Blog.list_posts_with_filter() do
        [] -> [nil, []]
        [head | tail] -> [head, tail]
        {:error, _reason} -> [nil, []]
      end

    render(conn, :show,
      current_path: current_path,
      error_message: nil,
      main_new: first_post,
      news: remaining_posts
    )
  end
end
