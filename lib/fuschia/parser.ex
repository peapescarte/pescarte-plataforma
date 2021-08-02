defmodule Fuschia.Parser do
  @moduledoc """
  Defines the contract to parse custom attributes
  """

  ####         ####
  #### STRINGS ####
  ####         ####

  @doc """
  Parses the given `map` with nested ids in order to conform to current schema definition.

  ## Examples

      iex> parse_nested_ids(%{"linha_pesquisa" => %{"id" => 1}, "pesquisador_id" => 2})
      %{"linha_pesquisa" => %{"id" => 1}, "linha_pesquisa_id" => 1, "pesquisador_id" => 2}

  """
  @callback parse_nested_ids(map) :: map

  @doc ~S"""
  Remove all whitespaces given a string

  ## Examples

      iex> remove_whitespaces(" Jose  Silva  ")
      "Jose Silva"

  """
  @spec remove_whitespaces(String.t()) :: String.t()
  def remove_whitespaces(s) when is_binary(s) do
    s
    |> String.replace(~r/\s+/, " ")
    |> String.trim(" ")
  end

  @doc ~S"""
  Capitalize each word given a string

  ## Examples

      iex> capitalize_all_words("matheus PESSANHA")
      "Matheus Pessanha"

  """
  @spec capitalize_all_words(String.t()) :: String.t()
  def capitalize_all_words(s) when is_binary(s) do
    s
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  @doc ~S"""
  Remove all utf-8 digits given a string,
  converting them to nfd format

  ## Examples

      iex> remove_accents("olá")
      "ola"

  """
  @spec remove_accents(String.t()) :: String.t()
  def remove_accents(s) when is_binary(s) do
    s
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-z\s]/u, "")
  end

  ####      ####
  #### MAPS ####
  ####      ####

  @doc ~S"""
  Converts a map to a keyword list

  ## Examples

      iex> map_to_keyword(%{a: 1, b: 2})
      [a: 1, b: 2]

  """
  @spec map_to_keyword(map) :: keyword
  def map_to_keyword(map) when is_map(map) do
    map
    |> Enum.map(fn {k, v} ->
      k = apply_if(k, is_binary(k), &String.to_existing_atom/1)
      {k, v}
    end)
  end

  @doc ~S"""
  Converts a string map to an atom map

  ## Examples

      iex> atomize_map(%{"a" => 1, "b" => 2})
      %{a: 1, b: 2}

  """
  @spec atomize_map(map) :: map
  def atomize_map(map) when is_map(map) do
    map
    |> map_to_keyword()
    |> Map.new()
  end

  def atomize_map(value), do: value

  @doc ~S"""
  Converts an antom map to a string map

  ## Examples

      iex> stringfy_map(%{a: 1, b: 2})
      %{"a" => 1, "b" => 2}

  """
  @spec stringfy_map(map) :: map
  def stringfy_map(map) when is_map(map) do
    map
    |> Enum.map(fn {k, v} -> {Atom.to_string(k), v} end)
    |> Map.new()
  end

  @doc ~S"""
  Remove all null values from a map/struct

  ## Examples

      iex> reject_empty(%{a: 1, b: nil, c: 2})
      %{a: 1, c: 2}

  """
  @spec reject_empty(map) :: map
  def reject_empty(map) when is_map(map) do
    :maps.filter(fn _, v -> !is_nil(v) end, map)
  end

  ####         ####
  #### HELPERS ####
  ####         ####

  @spec to_boolean(String.t()) :: boolean | nil
  def to_boolean("true"), do: true
  def to_boolean("false"), do: false
  def to_boolean(_), do: nil

  # Only execute a function if the condition is truthy
  # otherwise returns the same value
  @spec apply_if(term, boolean, fun, list) :: term
  defp apply_if(value, condition, function, args \\ []) do
    if condition, do: apply(function, [value | args]), else: value
  end

  @doc ~S"""
  Check if a given string is a number

  ## Examples

      iex> is_digit?("0")
      true

      iex> is_digit?("a")
      false

  """
  @spec is_digit?(String.t()) :: boolean
  def is_digit?(ch) when is_binary(ch) do
    "0" <= ch and ch <= "9"
  end

  @doc ~S"""
  Check if a given string is into alphabet

  ## Examples

      iex> is_digit?("0")
      true

      iex> is_digit?("a")
      false

  """
  @spec is_letter?(String.t()) :: boolean
  def is_letter?(ch) when is_binary(ch) do
    alphabet =
      ?A..?Z
      |> Enum.concat(?a..?z)
      |> Enum.map(&<<&1>>)

    ch in alphabet
  end

  @spec slugify(String.t()) :: String.t()
  def slugify(str) when is_binary(str) do
    str
    |> String.trim()
    |> String.normalize(:nfd)
    |> String.replace(~r/\s\s+/, " ")
    |> String.replace(~r/[^A-z\s\d-]/u, "")
    |> String.replace(~r/\s/, "_")
    |> String.replace(~r/--+/, "_")
    |> String.downcase()
  end
end
