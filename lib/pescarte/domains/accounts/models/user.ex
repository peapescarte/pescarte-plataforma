defmodule Pescarte.Domains.Accounts.Models.User do
  use Pescarte, :model

  import Brcpfcnpj.Changeset, only: [validate_cpf: 2]

  alias Pescarte.Domains.Accounts.Models.Contato
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @valid_roles ~w(pesquisador pescador admin avulso)a
  @required_fields ~w(first_name last_name cpf birthdate)a
  @optional_fields ~w(confirmed_at middle_name role)a
  # @update_fields ~w(first_name middle_name last_name permissions)a

  @lower_pass_format ~r/[a-z]/
  @upper_pass_format ~r/[A-Z]/
  @special_pass_format ~r/[!?@#$%^&*_0-9]/

  schema "user" do
    field :cpf, TrimmedString
    field :confirmed_at, :naive_datetime
    field :password_hash, :string, redact: true
    field :password, TrimmedString, virtual: true, redact: true
    field :birthdate, :date
    field :role, Ecto.Enum, default: :avulso, values: @valid_roles
    field :first_name, CapitalizedString
    field :middle_name, CapitalizedString
    field :last_name, CapitalizedString
    field :public_id, :string
    field :avatar_link, :string

    has_one :pesquisador, Pesquisador
    belongs_to :contato, Contato, on_replace: :update

    timestamps()
  end

  def full_name(user) do
    names = [user.first_name, user.middle_name, user.last_name]

    Enum.join(names, " ")
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_cpf(:cpf)
    |> unique_constraint(:cpf)
    |> cast_assoc(:contato, required: true, with: &Contato.changeset/2)
    |> put_change(:public_id, Nanoid.generate())
  end

  def pesquisador_changeset(attrs) do
    attrs
    |> changeset()
    |> put_change(:role, :pesquisador)
    |> password_changeset(attrs)
  end

  def admin_changeset(attrs) do
    attrs
    |> changeset()
    |> put_change(:role, :admin)
  end

  def confirm_changeset(%__MODULE__{} = user, now) do
    change(user, confirmed_at: now)
  end

  def email_changeset(%{contato: nil} = user, attrs) do
    user |> cast(attrs, []) |> validate_required([:contato])
  end

  def email_changeset(%{contato: contato}, attrs) do
    contato
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end

  def password_changeset(changeset, attrs \\ %{}, opts \\ []) do
    changeset
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_confirmation(:password, required: true)
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
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:password_hash, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  def list_by_query(fields) do
    from u in __MODULE__, select: ^fields
  end

  def get_by_email_query(email) do
    from u in __MODULE__,
      left_join: c in assoc(u, :contato),
      where: fragment("lower(?)", c.email) == ^email,
      order_by: [desc: u.inserted_at],
      limit: 1
  end

  def user_roles, do: @valid_roles
end
