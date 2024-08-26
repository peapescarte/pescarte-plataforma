defmodule Pescarte.Result do
  @moduledoc """
  O módulo `Pescarte.Result` fornece funções utilitárias para lidar com resultados que podem ser bem-sucedidos (`:ok` ou `{:ok, term}`) ou erros (`{:error, term}`). Este módulo ajuda a gerenciar o fluxo de controle e tratamento de erros de forma clara e funcional.

  ### Mônada Result (ou Either)

  A ideia por trás da mônada Result (ou Either) é encapsular a lógica de sucesso e erro em um único tipo de dados. Em vez de lançar exceções ou lidar com valores nulos, a mônada Result permite que as operações retornem explicitamente um valor de sucesso ou um erro, promovendo um estilo de programação mais seguro e robusto.

  No Elixir, utilizamos o formato `{:ok, term}` para indicar sucesso e `{:error, term}` para indicar falha. Isso permite compor operações sequenciais sem a necessidade de constantes verificações de erro, utilizando funções como `and_then/2` para encadear operações e `or_else/2` para tratar erros.

  ### Referências para Estudo

  - [Mônadas em Programação](https://en.wikipedia.org/wiki/Monad_(functional_programming)) - Explicação geral sobre mônadas na programação funcional.
  - [Result and Option in Rust](https://doc.rust-lang.org/std/result/) - Documentação sobre o tipo `Result` em Rust, que é uma inspiração para esse padrão em Elixir.
  - [Understanding Either Monad in Haskell](https://www.schoolofhaskell.com/school/to-infinity-and-beyond/pick-of-the-week/either-monad) - Explicação detalhada sobre a mônada Either em Haskell, outra fonte de inspiração.
  """

  @type t :: :ok | {:ok, term} | {:error, term}

  @doc """
  Cria um novo `Result` representando uma operação de sucesso

  ## Exemplos

      iex> Pescarte.Result.ok()
      :ok

      iex> Pescarte.Result.ok(%{foo: "bar"})
      {:ok, %{foo: "bar"}}
  """
  @spec ok :: t
  @spec ok(term) :: t
  def ok, do: :ok
  def ok(val), do: {:ok, val}

  @doc """
  Cria um novo `Result` representando uma operação de erro

  ## Exemplos

      iex> Pescarte.Result.err("Não foi possível enviar este email")
      {:error, "Não foi possível enviar este email"}

      iex> Pescarte.Result.err({:rate_limited, "Número máximo de acessos"})
      {:error, {:rate_limited, "Número máximo de acessos"}}
  """
  @spec err(term) :: t
  def err(reason), do: {:error, reason}

  @doc """
  Extrai o resultado para obter o valor ou erro contido.

  ## Exemplos

      iex> Konta.Result.unwrap(:ok)
      nil

      iex> Konta.Result.unwrap({:ok, 42})
      42

      iex> Konta.Result.unwrap({:error, "Algo deu errado"})
      "Algo deu errado"
  """
  @spec unwrap(t) :: term
  def unwrap(:ok), do: nil
  def unwrap({:ok, data}), do: data
  def unwrap({:error, err}), do: err

  @doc """
  Aplica uma função ao valor contido em um `{:ok, term}` e retorna um novo `Result`.

  ## Exemplos

      iex> result = {:ok, 2}
      iex> Konta.Result.and_then(result, fn x -> {:ok, x * 2} end)
      {:ok, 4}

      iex> result = {:error, "Algo deu errado"}
      iex> Konta.Result.and_then(result, fn x -> {:ok, x * 2} end)
      {:error, "Algo deu errado"}
  """
  @spec and_then(t, (t -> t)) :: t
  def and_then(:ok, _fun), do: :ok
  def and_then({:error, _} = err, _fun), do: err

  def and_then({:ok, data}, fun) do
    case fun.(data) do
      {:ok, new_data} -> {:ok, new_data}
      {:error, reason} -> {:error, reason}
      :ok -> :ok
    end
  end

  @doc """
  Executa uma função para tentar corrigir um erro, se houver.

  ## Exemplos

      iex> result = {:error, "Erro inicial"}
      iex> Konta.Result.or_else(result, fn _ -> {:ok, 42} end)
      {:ok, 42}

      iex> result = {:ok, 10}
      iex> Konta.Result.or_else(result, fn _ -> {:ok, 42} end)
      {:ok, 10}
  """
  @spec or_else(t, (t -> t)) :: t
  def or_else(:ok, _fun), do: :ok
  def or_else({:ok, data}, _fun), do: {:ok, data}
  def or_else({:error, err}, fun), do: fun.(err)

  @doc """
  Aplica uma função ao erro contido em um `{:error, term}` e retorna um novo `Result`.

  ## Exemplos

      iex> result = {:error, "Erro inicial"}
      iex> Konta.Result.map_error(result, fn _ -> "Erro mapeado" end)
      {:error, "Erro mapeado"}

      iex> result = {:ok, 10}
      iex> Konta.Result.map_error(result, fn _ -> "Erro mapeado" end)
      {:ok, 10}
  """
  @spec map_error(t, (t -> t)) :: t
  def map_error(:ok, _fun), do: :ok
  def map_error({:ok, _} = ok, _fun), do: ok
  def map_error({:error, err}, fun), do: {:error, fun.(err)}

  @doc """
  Retorna o valor contido em um `{:ok, term}`, ou um valor padrão se for um `{:error, term}`.

  ## Exemplos

      iex> result = {:ok, 10}
      iex> Konta.Result.unwrap_or(result, 42)
      10

      iex> result = {:error, "Erro"}
      iex> Konta.Result.unwrap_or(result, 42)
      42
  """
  @spec unwrap_or(t, term) :: term
  def unwrap_or(:ok, _default), do: :ok
  def unwrap_or({:ok, data}, _default), do: data
  def unwrap_or({:error, _}, default), do: default
end
