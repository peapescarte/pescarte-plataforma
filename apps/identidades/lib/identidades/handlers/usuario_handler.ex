defmodule Identidades.Handlers.UsuarioHandler do
  import Identidades.Services.ValidaSenhaUsuario

  alias Identidades.Handlers.IManageUsuarioHandler
  alias Identidades.Models.Usuario
  alias Identidades.Repository

  @behaviour IManageUsuarioHandler

  @impl true
  def build_usuario_name(usuario) do
    if usuario.sobrenome do
      usuario.primeiro_nome <> " " <> usuario.sobrenome
    else
      usuario.primeiro_nome
    end
  end

  @doc """
  Cria um usuário do tipo `:admin`.
  """
  @impl true
  def create_usuario_admin(attrs) do
    create_usuario(attrs, :admin)
  end

  @doc """
  Cria um usuário do tipo `:pesquisador`.
  """
  @impl true
  def create_usuario_pesquisador(attrs) do
    create_usuario(attrs, :pesquisador)
  end

  defp create_usuario(attrs, tipo) when tipo in ~w(pesquisador admin)a do
    attrs = Map.put(attrs, :tipo, tipo)

    %Usuario{}
    |> Usuario.changeset(attrs)
    |> Usuario.password_changeset(attrs)
    |> Repository.insert_usuario()
  end

  defp create_usuario(attrs, tipo) do
    attrs = Map.put(attrs, :tipo, tipo)

    %Usuario{}
    |> Usuario.changeset(attrs)
    |> Repository.insert_usuario()
  end

  @impl true
  defdelegate fetch_usuario_by_id_publico(id), to: Repository

  @doc """
  Busca um registro de `Usuario.t()`, com base no `:cpf`
  e na `:senha`, caso seja válida.

  ## Exemplos

      iex> fetch_usuario_by_cpf_and_password("12345678910", "123")
      {:ok, %Usuario{}}

      iex> fetch_usuario_by_cpf_and_password("12345678910", "invalid")
      {:error, :not_found}

      iex> fetch_usuario_by_cpf_and_password("invalid", "123")
      {:error, :not_found}

  """
  @impl true
  def fetch_usuario_by_cpf_and_password(cpf, pass) do
    with cpf <- handle_cpf(cpf),
         {:ok, user} <- Repository.fetch_usuario_by_cpf(cpf) do
      if valid_password?(user, pass) do
        {:ok, user}
      else
        {:error, :invalid_password}
      end
    end
  end

  @doc """
  Busca um registro de `Usuario.t()`, com base no `:email`
  e na `:senha`, caso seja válida.

  ## Exemplos

      iex> fetch_usuario_by_email_and_password("foo@example.com", "correct_password")
      {:ok, %Usuario{}}

      iex> fetch_usuario_by_email_and_password("foo@example.com", "invalid_password")
      {:error, :not_found}

  """
  @impl true
  def fetch_usuario_by_email_and_password(email, pass) do
    with {:ok, user} <- Repository.fetch_usuario_by_email(email) do
      if valid_password?(user, pass) do
        {:ok, user}
      else
        {:error, :invalid_password}
      end
    end
  end

  defp handle_cpf(cpf) do
    cpf
    |> String.replace(~r/[.-]/, "")
    |> String.trim()
  end

  @impl true
  defdelegate list_usuario, to: Repository
end
