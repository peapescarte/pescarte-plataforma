defmodule Fuschia.Accounts.User do
  use Fuschia.Schema

  import Ecto.Changeset
  import FuschiaWeb.Gettext

  alias Fuschia.Common.Formats
  alias Fuschia.Entities.{Contato, User}
  alias Fuschia.Types.{CapitalizedString, TrimmedString}

  @required_fields ~w(nome_completo cpf data_nascimento)a
  @optional_fields ~w(confirmed_at last_seen nome_completo ativo? role)a

  @valid_roles ~w(pesquisador pescador admin avulso)

  @lower_pass_format ~r/[a-z]/
  @upper_pass_format ~r/[A-Z]/
  @special_pass_format ~r/[!?@#$%^&*_0-9]/

  @cpf_format Formats.cpf()

  @primary_key {:cpf, TrimmedString, autogenerate: false}
  schema "user" do
    field :confirmed_at, :naive_datetime
    field :password_hash, TrimmedString, redact: true
    field :password, TrimmedString, virtual: true, redact: true
    field :data_nascimento, :date
    field :last_seen, :utc_datetime_usec
    field :role, TrimmedString, default: "avulso"
    field :nome_completo, CapitalizedString
    field :ativo?, :boolean, default: true
    field :permissoes, :map, virtual: true

    belongs_to :contato, Contato, on_replace: :update

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:cpf, @cpf_format)
    |> unique_constraint(:cpf, name: :user_pkey)
    |> unique_constraint(:cpf, name: :user_nome_completo_index)
    |> validate_inclusion(:role, @valid_roles)
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
    |> validate_inclusion(:role, @valid_roles)
    |> cast_assoc(:contato)
  end

  @doc """
  Um Changeset para cadastro de usuários.

  É importante validar o comprimento do e-mail e da senha.
  Caso contrário, os bancos de dados podem truncar o e-mail sem avisos, o que
  pode levar a um comportamento imprevisível ou inseguro. Senhas longas podem
  também ser muito caro fazer hash para certos algoritmos.

  ## Opções

  * `:password_hash` - Faz o hash da senha para que ela possa ser
      armazenada com segurança no banco de dados e garante que o campo
      de senha seja limpo para evitar vazamentos nos logs. Se o hash de
      senha não for necessário e limpar o campo de senha não é desejado
      (como ao usar este conjunto de alterações para validações em um
      formulário LiveView), esta opção pode ser definida como `false`.
      O padrão é `true`.
  """
  def registration_changeset(%__MODULE__{} = struct, attrs, opts \\ []) do
    struct
    |> changeset(attrs)
    |> put_change(:role, "avulso")
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_password(opts)
  end

  @doc """
  Changeset para criar usuários admin
  """
  @spec admin_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def admin_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> changeset(attrs)
    |> validate_required([:perfil])
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_length(:password, min: 12, max: 72)
    |> validate_format(:password, @lower_pass_format, message: "at least one lower case character")
    |> validate_format(:password, @upper_pass_format, message: "at least one upper case character")
    |> validate_format(:password, @special_pass_format,
      message: "at least one digit or punctuation character"
    )
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:password_hash, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  Um conjunto de alterações do usuário para alterar a senha.

   ## Opções

     * `:password_hash` - Faz o hash da senha para que ela possa ser armazenada com segurança
       no banco de dados e garante que o campo de senha seja limpo para evitar
       vazamentos nos logs. Se o hash de senha não for necessário e limpar o
       campo de senha não é desejado (como ao usar este conjunto de alterações para
       validações em um formulário LiveView), esta opção pode ser definida como `false`.
       O padrão é `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_confirmation(:password,
      required: true,
      message: dgettext("errors", "does not match password")
    )
    |> validate_password(opts)
  end

  @doc """
  A contact changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  @spec email_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def email_changeset(%__MODULE__{contato: nil} = user, attrs),
    do: user |> cast(attrs, []) |> validate_required([:contato])

  def email_changeset(%__MODULE__{contato: contact}, attrs) do
    contact
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> Contato.validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, dgettext("errors", "didn't change"))
    end
  end

  @doc """
  Confirma um usuário atualizando `confirmed_at`,
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifica a senha.

  Se não houver usuário ou o usuário não tiver uma senha, chamamos
  `Bcrypt.no_user_verify/0` para evitar ataques de tempo.
  """
  def valid_password?(%__MODULE__{password_hash: password_hash}, password)
      when is_binary(password_hash) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, password_hash)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Valida a senha atual, caso contrário adiciona erro ao Changeset
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  def for_jwt(%__MODULE__{} = struct) do
    %{
      email: struct.contato.email,
      endereco: struct.contato.endereco,
      celular: struct.contato.celular,
      nomeCompleto: struct.nome_completo,
      perfil: struct.role,
      permissoes: struct.permissoes,
      cpf: struct.cpf,
      dataNascimento: struct.data_nascimento
    }
  end

  def to_map(%__MODULE__{} = struct) do
    %{
      nome_completo: struct.nome_completo,
      perfil: struct.role,
      ultimo_login: struct.last_seen,
      confirmado_em: struct.confirmed_at,
      ativo: struct.ativo?,
      data_nascimento: struct.data_nascimento
    }
  end

  defimpl Jason.Encoder, for: User do
    alias Fuschia.Accounts.User

    @spec encode(User.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> User.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
