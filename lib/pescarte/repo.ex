defmodule Pescarte.Repo do
  use Ecto.Repo,
    otp_app: :pescarte,
    adapter: Ecto.Adapters.Postgres

  @type changeset :: Ecto.Changeset.t()
  @type query :: Ecto.Query.t()

  @callback all(module | query) :: list(struct)
  @callback delete(struct) :: {:ok, struct} | {:error, changeset}
  @callback get(module | query, integer) :: {:ok, struct} | {:error, :not_found}
  @callback get_by(module | query, keyword) :: {:ok, struct} | {:error, :not_found}
  @callback insert(changeset) :: {:ok, struct} | {:error, changeset}
  @callback insert_or_update(changeset) :: {:ok, struct} | {:error, changeset}
  @callback update(struct, map) :: {:ok, struct} | {:error, changeset}

  @optional_callbacks get_by: 2, insert_or_update: 1
end
