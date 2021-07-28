defmodule Fuschia.ContextBehaviour do
  @moduledoc """
  Contracto to define an Entity Context
  """

  @callback list :: list(struct)

  @callback one(integer) :: struct | nil

  @callback create(map) :: {:ok, struct} | {:error, %Ecto.Changeset{}}

  @callback update(integer, map) :: {:ok, struct} | {:error, %Ecto.Changeset{}}

  @callback query :: %Ecto.Query{}

  @callback preload_all(struct) :: struct

  @callback preload_all(%Ecto.Query{}) :: %Ecto.Query{}
end
