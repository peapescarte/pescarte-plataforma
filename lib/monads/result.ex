defmodule Monads.Result do
  @moduledoc """
  Cria um tipo de dado explicíto que representa uma operação
  que foi realizada com sucesso ou um erro, que possui uma razão.
  """

  alias Monads.Maybe

  defmodule Error do
    defexception [:message]
  end

  @type t(a, b) :: {:ok, a} | {:error, b}

  @doc """
  Cria um `Result.t` que representa um sucesso.
  """
  def ok(v), do: {:ok, v}

  @doc """
  Cria um `Result.t` que representa um erro.
  """
  def error(reason), do: {:error, reason}

  @doc """
  Aplica uma função `f/1` no valor encapsulado caso seja uma
  operação de sucesso. Caso seja um erro, nada é modificado.

  ## Exemplos
      iex> Result.map(Result.error(:invalid), &String.length/1)
      {:error, :invalid}

      iex> Result.map(Result.ok("ola"), &String.length/1)
      {:ok, 3}
  """
  def map({:error, _} = err, _), do: err
  def map({:ok, v}, f), do: ok(f.(v))

  @doc """
  Retorna o valor de sucesso encapsulado ou em caso de erro, retorna
  a razão.

  ## Exemplos
      iex> Result.unwrap_or(Result.error(:invalid), "default")
      "default"

      iex> Result.unwrap_or(Result.ok("ola"), "default")
      "ola"
  """
  def unwrap_or({:error, _}, default), do: default
  def unwrap_or({:ok, v}, _), do: v

  @doc """
  Retorna o valor de sucesso ou lança uma exceção com a razão do erro.
  """
  def unwrap!({:error, err}), do:
    raise(Error, "Erro ao desencapsular `Result`: #{inspect(err)}")

  def unwrap!({:ok, v}), do: v

  @doc """
  Transforma um `Result.t` em um `Maybe.t`.

  ## Exemplos
      iex> Result.to_maybe(Result.error(:invalid))
      :none

      iex> Result.to_maybe(Result.ok(:valid))
      {:some, :valid}
  """
  def to_maybe({:error, _}), do: Maybe.none()
  def to_maybe({:ok, v}), do: Maybe.some(v)

  @doc """
  Retorna verdadeiro no caso do valor ser um sucesso e falso caso seja um erro.
  """
  def ok?({:error, _}), do: false
  def ok?({:ok, _}), do: true

  @doc """
  Retorna falso no caso do valor ser um sucesso e verdadeiro caso seja um erro.
  """
  def error?({:error, _}), do: false
  def error?({:ok, _}), do: true
end
