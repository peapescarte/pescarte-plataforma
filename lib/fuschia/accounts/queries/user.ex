defmodule Fuschia.Accounts.Queries.UserQueries do
  @moduledoc false

  import Ecto.Query, only: [from: 2, where: 3, order_by: 3, limit: 2]

  alias Fuschia.Accounts.Models.UserModel

  @behaviour Fuschia.Query

  @impl true
  def query do
    from u in UserModel,
      left_join: contato in assoc(u, :contato),
      order_by: [desc: u.inserted_at]
  end

  def get_by_email_query(email) do
    query()
    |> where([u, contato], fragment("lower(?)", contato.email) == ^email)
    |> where([u], u.ativo? == true)
    |> order_by([u], desc: u.inserted_at)
    |> limit(1)
  end

  def exist_query(cpf) do
    where(query(), [u], u.cpf == ^cpf)
  end

  @impl true
  def relationships, do: [:contato]
end
