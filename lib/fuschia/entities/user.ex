defmodule Fuschia.Entities.User do
  @moduledoc """
  User schema
  """

  use Fuschia.Schema

  import Ecto.Changeset

  alias Fuschia.Common.Formats
  alias Fuschia.Entities.{Contato, User}
  alias Fuschia.Types.{CapitalizedString, TrimmedString}

  @required_fields ~w(nome_completo cpf data_nascimento)a
  @optional_fields ~w(password confirmed last_seen nome_completo ativo perfil)a

  @valid_perfil ~w(pesquisador pescador admin avulso)

  @lower_pass_format ~r/[a-z]/
  @upper_pass_format ~r/[A-Z]/
  @special_pass_format ~r/[!?@#$%^&*_0-9]/

  @cpf_format Formats.cpf()

  @primary_key {:cpf, TrimmedString, autogenerate: false}
  schema "user" do
    field :password_hash, TrimmedString
    field :confirmed, :boolean, default: false
    field :data_nascimento, :date
    field :last_seen, :utc_datetime_usec
    field :perfil, TrimmedString, default: "avulso"
    field :nome_completo, CapitalizedString
    field :ativo, :boolean, default: true
    field :password, TrimmedString, virtual: true
    field :permissoes, :map, virtual: true
    field :is_admin, :boolean, virtual: true, default: false

    belongs_to :contato, Contato, on_replace: :update

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:cpf, @cpf_format)
    |> unique_constraint(:cpf, name: :user_pkey)
    |> unique_constraint(:cpf, name: :user_nome_completo_index)
    |> validate_inclusion(:perfil, @valid_perfil)
    |> cast_assoc(:contato, required: true)
    |> foreign_key_constraint(:cpf, name: :pesquisador_usuario_cpf_fkey)
  end

  @spec update_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_format(:cpf, @cpf_format)
    |> unique_constraint(:cpf, name: :user_pkey)
    |> unique_constraint(:cpf, name: :user_nome_completo_index)
    |> validate_inclusion(:perfil, @valid_perfil)
    |> cast_assoc(:contato)
  end

  @doc """
  Changeset for user signup
  """
  @spec registration_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def registration_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> changeset(attrs)
    |> put_change(:perfil, "avulso")
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_password()
    |> put_hashed_password()
  end

  @doc """
  Changeset for users created on admin
  """
  @spec admin_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def admin_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> changeset(attrs)
    |> validate_required([:perfil])
  end

  @doc """
  A user changeset for changing the password.
  """
  @spec password_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
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
  @spec confirm_changeset(%__MODULE__{}) :: Ecto.Changeset.t()
  def confirm_changeset(user) do
    change(user, confirmed: true)
  end

  @spec for_jwt(%__MODULE__{}) :: map
  def for_jwt(%__MODULE__{} = struct) do
    %{
      email: struct.contato.email,
      endereco: struct.contato.endereco,
      celular: struct.contato.celular,
      nomeCompleto: struct.nome_completo,
      perfil: struct.perfil,
      permissoes: struct.permissoes,
      cpf: struct.cpf,
      dataNascimento: struct.data_nascimento
    }
  end

  @doc """
  Verifies the password.

  If there is no usuario or the usuario doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  @spec valid_password?(%__MODULE__{}, String.t()) :: bool
  def valid_password?(%User{password_hash: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_invalid_hash, _invalid_password) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  @spec validate_current_password(Ecto.Changeset.t(), String.t()) :: Ecto.Changeset.t()
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

      _no_password ->
        changeset
    end
  end

  defimpl Jason.Encoder, for: User do
    @spec encode(Fuschia.Entities.User.t(), map) :: map
    def encode(struct, opts) do
      Fuschia.Encoder.encode(
        %{
          nome_completo: struct.nome_completo,
          perfil: struct.perfil,
          ultimo_login: struct.last_seen,
          confirmado: struct.confirmed,
          ativo: struct.ativo,
          data_nascimento: struct.data_nascimento
        },
        opts
      )
    end
  end
end
