defmodule Fuschia.Context.ApiKeys do
  @moduledoc """
  Public Fuschia ApiKeys API
  """

  import Ecto.Query

  alias Fuschia.Entities.ApiKey
  alias Fuschia.Repo

  @spec one :: %ApiKey{}
  def one do
    Repo.one(query())
  end

  @spec one_by_key(String.t()) :: %ApiKey{} | nil
  def one_by_key(key) do
    Repo.get_by(query(), key: key)
  end

  @spec query :: Ecto.Query.t()
  def query do
    from a in ApiKey,
      where: a.active == true
  end
end
