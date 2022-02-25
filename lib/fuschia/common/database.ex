defmodule Fuschia.Common.Database do
  @moduledoc """
  Define funções genéricas que abstraem a API do
  módulo Fuschia.Database
  """

  alias Fuschia.Database

  def create_and_preload(source, attrs, opts) do
    entity_query_mod = get_queries_mod(opts, source)

    with {:ok, entity} <- Database.create(source, attrs),
         %^source{} = preloaded <-
           Database.preload_all(entity, entity_query_mod.relationships()) do
      {:ok, preloaded}
    end
  end

  def get_entity(source, id, opts) do
    queries_mod = get_queries_mod(opts, source)
    query_func = Keyword.get(opts, :query_func) || :query
    query_args = get_query_args(opts)

    queries_mod
    |> apply(query_func, query_args)
    |> Database.get(id, queries_mod.relationships())
  end

  def list_entity(source, opts) do
    queries_mod = get_queries_mod(opts, source)
    query_func = Keyword.get(opts, :query_func) || :query
    query_args = get_query_args(opts)

    queries_mod
    |> apply(query_func, query_args)
    |> Database.list(queries_mod.relationships())
  end

  defp get_queries_mod(opts, mod) do
    suffix = mod |> to_string() |> String.split(".") |> List.last()

    opts
    |> Keyword.get(:queries_mod)
    |> Module.safe_concat(suffix)
  end

  defp get_query_args(opts) do
    case Keyword.get(opts, :query_args) do
      nil -> []
      args when is_list(args) -> args
      arg -> [arg]
    end
  end
end
