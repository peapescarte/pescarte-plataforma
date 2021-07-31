defmodule Fuschia.Entities.User do
  @moduledoc """
  User schema
  """

  use Fuschia.Schema

  import Ecto.Changeset

  alias Fuschia.Common.Formats
  alias Fuschia.Entities.{Contato, User}
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(nome_completo cpf data_nascimento)a
  @optional_fields ~w(password confirmed last_seen nome_completo ativo perfil)a

  @valid_perfil ~w(pesquisador pescador admin avulso)

  @lower_pass_format ~r/[a-z]/
  @upper_pass_format ~r/[A-Z]/
  @special_pass_format ~r/[!?@#$%^&*_0-9]/

  @cpf_format Formats.cpf()

  schema "user" do
    field :password_hash, TrimmedString
    field :confirmed, :boolean, default: false
    field :data_nascimento, :date
    field :cpf, TrimmedString
    field :last_seen, :utc_datetime_usec
    field :perfil, TrimmedString
    field :nome_completo, TrimmedString
    field :ativo, :boolean, default: true
    field :password, TrimmedString, virtual: true
    field :permissoes, :map, virtual: true
    field :is_admin, :boolean, virtual: true, default: false

    belongs_to :contato, Contato, on_replace: :update

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:cpf, @cpf_format)
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
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_password()
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

  @doc """
  A user changeset for changing the password.
  """
  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_password()
    |> put_hashed_password()
  end

  @doc """
  Confirms the account by setting `confirmed`.
  """
  def confirm_changeset(user) do
    change(user, confirmed: true)
  end

  def for_jwt(%__MODULE__{} = struct) do
    %{
      email: struct.contato.email,
      endereco: struct.contato.endereco,
      celular: struct.contato.celular,
      nomeCompleto: struct.nome_completo,
      perfil: struct.perfil,
      id: struct.id,
      permissoes: struct.permissoes,
      cpf: struct.cpf,
      dataNasc: struct.data_nascimento
    }
  end

  @doc """
  Verifies the password.

  If there is no usuario or the usuario doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%User{password_hash: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  defp validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 8, max: 80)
    |> validate_format(:password, @lower_pass_format, message: "at least one lower case character")
    |> validate_format(:password, @upper_pass_format, message: "at least one upper case character")
    |> validate_format(:password, @special_pass_format,
      message: "at least one digit or punctuation character"
    )
    |> validate_confirmation(:password, required: true)
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
        ativo: struct.ativo,
        data_nasc: struct.data_nascimento
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
