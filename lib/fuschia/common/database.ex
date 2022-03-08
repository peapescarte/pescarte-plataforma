defmodule Fuschia.Common.Database do
  @moduledoc """
  Define funções genéricas que abstraem a API do
  módulo Fuschia.Database
  """

  alias Fuschia.Database

  def create_and_preload(source, attrs, opts) do
    entity_query_mod = get_queries_mod(opts, source)
    change_fun = Keyword.get(opts, :change_fun, :changeset)

    create_fun =
      if change_fun == :changeset,
        do: &Database.create(source, &1),
        else: &Database.create_with_custom_changeset(source, change_fun, &1)

    with {:ok, entity} <- create_fun.(attrs),
         %^source{} = preloaded <-
           Database.preload_all(entity, entity_query_mod.relationships()) do
      {:ok, preloaded}
    end
  end

  def update_and_preload(%source{} = struct, attrs, opts) do
    entity_query_mod = get_queries_mod(opts, source)
    change_fun = Keyword.get(opts, :change_fun, :changeset)

    with {:ok, entity} <- Database.update(struct, attrs, change_fun),
         ^struct = preloaded <-
           Database.preload_all(entity, entity_query_mod.relationships()) do
      {:ok, preloaded}
    end
  end

  def get_entity(source, id, opts) do
    queries_mod = get_queries_mod(opts, source)
    query_fun = Keyword.get(opts, :query_fun) || :query
    query_args = get_query_args(opts)

    queries_mod
    |> apply(query_fun, query_args)
    |> Database.get(id, queries_mod.relationships())
  end

  def get_entity_by(source, args, opts) do
    queries_mod = get_queries_mod(opts, source)
    query_fun = Keyword.get(opts, :query_fun) || :query
    query_args = get_query_args(opts)

    queries_mod
    |> apply(query_fun, query_args)
    |> Database.get_by(queries_mod.relationships(), args)
  end

  def list_entity(source, opts) do
    queries_mod = get_queries_mod(opts, source)
    query_fun = Keyword.get(opts, :query_fun) || :query
    query_args = get_query_args(opts)

    queries_mod
    |> apply(query_fun, query_args)
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
