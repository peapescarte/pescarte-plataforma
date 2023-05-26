defmodule Pescarte.Domains.Accounts.Models.User do
  use Pescarte, :model

  import Brcpfcnpj.Changeset, only: [validate_cpf: 2]

  alias Pescarte.Domains.Accounts.Models.Contato
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @valid_roles ~w(pesquisador pescador admin avulso)a

  @required_fields ~w(primeiro_nome sobrenome cpf data_nascimento)a
  @optional_fields ~w(confirmado_em)a

  @lower_pass_format ~r/[a-z]/
  @upper_pass_format ~r/[A-Z]/
  @special_pass_format ~r/[!?@#$%^&*_0-9]/

  schema "usuario" do
    field :cpf, TrimmedString
    field :confirmado_em, :naive_datetime
    field :hash_senha, :string, redact: true
    field :senha, TrimmedString, virtual: true, redact: true
    field :data_nascimento, :date
    field :tipo, Ecto.Enum, default: :avulso, values: @valid_roles
    field :primeiro_nome, CapitalizedString
    field :sobrenome, CapitalizedString
    field :id_publico, :string
    field :ativo?, :boolean, default: false

    has_one :pesquisador, Pesquisador
    belongs_to :contato, Contato, on_replace: :update

    timestamps()
  end

  def full_name(user) do
    names = [user.primeiro_nome, user.sobrenome]

    Enum.join(names, " ")
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_cpf(:cpf)
    |> unique_constraint(:cpf)
    |> cast_assoc(:contato, required: true, with: &Contato.changeset/2)
    |> put_change(:id_publico, Nanoid.generate())
  end

  def pesquisador_changeset(attrs) do
    attrs
    |> changeset()
    |> put_change(:tipo, :pesquisador)
    |> password_changeset(attrs)
  end

  def admin_changeset(attrs) do
    attrs
    |> changeset()
    |> put_change(:tipo, :admin)
  end

  def confirm_changeset(%__MODULE__{} = user, now) do
    change(user, confirmado_em: now)
  end

  def email_changeset(%{contato: nil} = user, attrs) do
    user |> cast(attrs, []) |> validate_required([:contato])
  end

  def email_changeset(%{contato: contato}, attrs) do
    contato
    |> cast(attrs, [:email_principal])
    |> validate_required([:email_principal])
  end

  def password_changeset(changeset, attrs \\ %{}, opts \\ []) do
    changeset
    |> cast(attrs, [:senha])
    |> validate_required([:senha])
    |> validate_confirmation(:senha, required: true)
    |> validate_length(:senha, min: 12, max: 72)
    |> validate_format(:senha, @lower_pass_format, message: "pelo menos uma letra minúscula")
    |> validate_format(:senha, @upper_pass_format, message: "pelo menos uma letra maiúscula")
    |> validate_format(:senha, @special_pass_format,
      message: "pelo menos um digito ou caractere digital"
    )
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_senha, true)
    password = get_change(changeset, :senha)

    if hash_password? && password && changeset.valid? do
      changeset
      |> validate_length(:senha, max: 72, count: :bytes)
      |> put_change(:senha, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:senha)
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
      where: fragment("lower(?)", c.email_principal) == ^email,
      order_by: [desc: u.inserted_at],
      limit: 1
  end

  def user_roles, do: @valid_roles
end
