defmodule Fuschia.Common.Database do
  @moduledoc """
  Define funções genéricas que abstraem a API do
  módulo Fuschia.Database
  """

  alias Fuschia.Database

  def create_and_preload(source, attrs, queries_mod: queries_mod) do
    entity_query_mod = append_to_queries_mod(queries_mod, source)

    with {:ok, entity} <- Database.create(source, attrs),
         %^source{} = preloaded <-
           Database.preload_all(entity, entity_query_mod.relationships()) do
      {:ok, preloaded}
    end
  end

  def get_entity(source, id, queries_mod: queries_mod) do
    queries_mod
    |> append_to_queries_mod(source)
    |> apply(:query, [])
    |> Database.get(id)
  end

  def list_entity(source, opts, queries_mod: queries_mod) do
    queries_mod
    |> append_to_queries_mod(source)
    |> apply(:query, [])
    |> Database.list(opts)
  end

  defp append_to_queries_mod(queries_mod, mod) do
    Module.safe_concat(queries_mod, mod)
  end
end
