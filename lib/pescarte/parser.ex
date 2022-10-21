defmodule Backend.Helpers do
  @moduledoc """
  Implementa funções de ajuda para deixar o fluxo
  mais claro e legível
  """

  @doc ~S"""
  Remove todos os espaços em branco de uma string.

  ## Examples

      iex> trim(" Jose  Silva  ")
      "Jose Silva"

  """
  @spec trim(binary) :: String.t()
  def trim(s) when is_binary(s) do
    s
    |> String.replace(~r/\s+/, " ")
    |> String.trim(" ")
  end

  @doc ~S"""
  Transforma a primeira letra de cada palavra em maiúscula
  enquanto as restantes ficam em minúscula.

  ## Examples

      iex> capitalize_all_words("zoey PESSANHA")
      "Zoey Pessanha"

  """
  @spec capitalize_all_words(binary) :: String.t()
  def capitalize_all_words(s) when is_binary(s) do
    s
    |> String.split(" ")
    |> Enum.map_join(" ", &String.capitalize/1)
  end

  @doc ~S"""
  Remote todos os caracteres utf-8 de uma string.

  ## Examples

      iex> remove_accents("olá")
      "ola"

  """
  @spec remove_accents(binary) :: String.t()
  def remove_accents(s) when is_binary(s) do
    s
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-z\s]/u, "")
  end

  @doc ~S"""
  Converte um mapa para lista de palavras.

  ## Examples

      iex> map_to_keyword(%{a: 1, b: 2})
      [a: 1, b: 2]

  """
  @spec map_to_keyword(map) :: keyword
  def map_to_keyword(map) when is_map(map) do
    Enum.map(map, fn {k, v} ->
      k = apply_if(k, is_binary(k), &String.to_existing_atom/1)
      {k, v}
    end)
  end

  @doc ~S"""
  Converte um mapa de strings em um mapa de átomos.

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

  @doc ~S"""
  Converte um mapa de átomos em um mapa de strings.

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

  @spec to_boolean(binary) :: boolean | nil
  def to_boolean("true"), do: true
  def to_boolean("false"), do: false
  def to_boolean(_invalid), do: nil

  # Apenas executa uma função caso o predicado
  # seja verdadeiro, caso contrário retorna o mesmo
  # valor
  @spec apply_if(term, boolean, fun) :: term
  defp apply_if(value, condition, function) do
    if condition, do: function.(value), else: value
  end

  @doc ~S"""
  Verifica se uma string é um dígito numérico.

  ## Examples

      iex> is_digit?("0")
      true

      iex> is_digit?("a")
      false

  """
  @spec is_digit?(binary) :: boolean
  def is_digit?(ch) when is_binary(ch) do
    "0" <= ch and ch <= "9"
  end

  @doc ~S"""
  Verifica se uma string é uma letra.

  ## Examples

      iex> is_letter?("0")
      false

      iex> is_letter?("a")
      true

  """
  @spec is_letter?(binary) :: boolean
  def is_letter?(ch) when is_binary(ch) do
    alphabet =
      ?A..?Z
      |> Enum.concat(?a..?z)
      |> Enum.map(&<<&1>>)

    ch in alphabet
  end

  @doc """
  Transforma um átomo ou uma string em uma string
  válida em URLs.
  """
  @spec slugify(binary) :: String.t()
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

  def slugify(a) when is_atom(a) do
    slugify(Atom.to_string(a))
  end

  @doc """
  Encapsula um valor numa tupla de `:ok`.

  ### Exemplos
      iex> ok_wrap(1..4)
      {:ok, 1..4}
  """
  @spec ok_wrap(any) :: {:ok, any}
  def ok_wrap(term) do
    {:ok, term}
  end

  @doc """
  Desencapsula um valor de uma tupla de `:ok`.

  ### Exemplos
      iex> ok_unwrap({:ok, 1..4})
      1..4
  """
  @spec ok_unwrap({:ok, any}) :: any
  def ok_unwrap({:ok, term}) do
    term
  end

  @doc """
  Encapsula um valor numa tupla de `:error`.

  ### Exemplos
      iex> error_wrap(:not_found)
      {:error, :not_found}
  """
  @spec error_wrap(any) :: {:error, any}
  def error_wrap(term) do
    {:error, term}
  end

  @doc """
  Cria uma mônada `Maybe` que representa um
  resultado que pode haver falha, retornando
  uma tupla `{:ok, term}` ou `{:error, reason}`.
  Para mais leitura sobre mônadas: https://bit.ly/3QOZ6nY.

  ### Exemplos
      iex> maybe(nil)
      {:error, :not_found}

      iex> maybe([], reason: :empty)
      {:error, :empty}

      iex> maybe(%Struct{})
      {:ok, %Struct{}}
  """
  @spec maybe(term, keyword) :: {:ok, any} | {:error, any}
  def maybe(term, opts \\ []) do
    reason = Keyword.get(opts, :reason, :not_found)

    case term do
      [] -> error_wrap(reason)
      nil -> error_wrap(reason)
      _other -> ok_wrap(term)
    end
  end
end
