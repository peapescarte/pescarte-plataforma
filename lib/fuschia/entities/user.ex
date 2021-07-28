defmodule Fuschia.Entities.User do
  @moduledoc """
  User schema
  """

  use Fuschia.Schema

  import Ecto.Changeset

  alias Fuschia.Entities.User
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(nome_completo email cpf)a
  @optional_fields ~w(password confirmed last_seen nome_completo ativo perfil)a

  @valid_perfil ~w(pesquisador pescador admin avulso)

  schema "users" do
    field :password_hash, TrimmedString
    field :confirmed, :boolean
    field :email, TrimmedString
    field :cpf, TrimmedString
    field :last_seen, :utc_datetime_usec
    field :perfil, TrimmedString
    field :nome_completo, TrimmedString
    field :ativo, :boolean, default: true
    field :password, TrimmedString, virtual: true
    field :permissoes, :map, virtual: true
    field :is_admin, :boolean, virtual: true

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:perfil, @valid_perfil)
    |> cast_assoc(:contato)
  end

  @doc """
  Changeset for user signup
  """
  def registration_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> changeset(attrs)
    |> put_change(:perfil, "avulso")
    |> validate_required([:password])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> put_hashed_password()
    |> cast_assoc(:contato, required: true)
  end

  @doc """
  Changeset for users created on admin
  """
  def admin_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> changeset(attrs)
    |> validate_required([:perfil])
    |> cast_assoc(:contato, required: true)
  end

  def for_jwt(%__MODULE__{} = struct) do
    %{
      email: struct.email,
      nomeCompleto: struct.nome_completo,
      perfil: struct.perfil,
      id: struct.id,
      permissoes: struct.permissoes,
      cpf: struct.cpf
    }
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end

  defimpl Jason.Encoder, for: User do
    def encode(struct, opts) do
      %{
        id: struct.id,
        nome_completo: struct.nome_completo,
        perfil: struct.perfil,
        ultimo_login: struct.last_seen,
        confirmado: struct.confirmed,
        ativo: struct.ativo
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
