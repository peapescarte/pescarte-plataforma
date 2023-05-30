defmodule Monads.Maybe do
  @moduledoc """
  Tipo de dados explcíto que representa a existência ou ausência
  de um valor.
  """

  alias Monads.Result

  defmodule Error do
    defexception [:message]
  end

  @type t(a) :: {:some, a} | :none

  @doc """
  Cria um valor que representa a ausência de um dado.
  """
  def none, do: :none

  @doc """
  Cria um valor que representa a existênciad de um dado.
  """
  def some(v), do: {:some, v}

  @doc """
  Cria um `Maybe.t()` a partir de valores nativos.

  ## Exemplos
      iex> Maybe.new(nil)
      :none

      iex> Maybe.new(42)
      {:some, 42}
  """
  def new(nil), do: none()
  def new(v), do: some(v)

  @doc """
  Aplica uma função `f/1` ao valor encapsulado, caso ele exista.

  ## Exemplos
      iex> Maybe.map(Maybe.none(), &String.length/1)
      :none

      iex> Maybe.map(Maybe.some("hello"), &String.length/1)
      {:some, 5}
  """
  def map(:none, _), do: :none
  def map({:some, v}, f), do: some(f.(v))

  @doc """
  Retorna verdadeiro caso o valor encapsulado exista e
  retorna falso caso contrário.
  """
  def some?(:none), do: false
  def some?({:some, _}), do: true

  @doc """
  Retorna falso caso o valor encapsulado exista e
  retorna verdadeiro caso contrário.
  """
  def none?(:none), do: true
  def none?({:some, _}), do: false

  @doc """
  Retorna o valor existente encapsulado ou em caso de não existir, retorna
  o "nada".

  ## Exemplos
      iex> Maybe.unwrap_or(Maybe.none(), "default")
      "default"

      iex> Maybe.unwrap_or(Maybe.some("ola"), "default")
      "ola"
  """
  def unwrap_or(:none, default), do: default
  def unwrap_or({:some, v}, _), do: v

  @doc """
  Retorna o valor existente ou lança uma exceção.
  """
  def unwrap!(:none), do:
    raise(Error, "Erro ao desencapsular `Maybe` sem valor existente")

  def unwrap!({:some, v}), do: v

  @doc """
  Transforma um `Maybe.t` em um `Result.t`.

  ## Exemplos
      iex> Maybe.to_result(Maybe.none(), :invalid)
      {:error, :invalid}

      iex> Maybe.to_result(Maybe.some(:valid))
      {:ok, :valid}
  """
  def to_result(:none, err), do: Result.error(err)
  def to_result({:some, v}), do: Result.ok(v)
end
