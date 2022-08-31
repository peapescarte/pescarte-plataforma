defmodule Fuschia.Accounts.IO.UserRepo do
  use Fuschia, :repo

  import Brcpfcnpj.Changeset, only: [validate_cpf: 2]

  alias Fuschia.Accounts.Models.User

  @required_fields ~w(first_name last_name cpf birthdate)a
  @optional_fields ~w(confirmed_at last_seen middle_name active? role)a
  @update_fields ~w(active? last_seen first_name middle_name last_name permissions)a

  @lower_pass_format ~r/[a-z]/
  @upper_pass_format ~r/[A-Z]/
  @special_pass_format ~r/[!?@#$%^&*_0-9]/

  @valid_roles ~w(pesquisador pescador admin avulso)

  @impl true
  def all do
    Database.all(User)
  end

  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_cpf(:cpf)
    |> unique_constraint(:cpf)
    |> validate_inclusion(:role, @valid_roles)
    |> cast_assoc(:contact, required: true)
    |> put_change(:public_id, Nanoid.generate())
  end

  def confirm_changeset(%User{} = user) do
    now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    change(user, confirmed_at: now)
  end

  def confirm_user(%User{} = user) do
    user
    |> confirm_changeset()
    |> Database.update()
  end

  def email_changeset(%User{contact: nil} = user, attrs) do
    user |> cast(attrs, []) |> validate_required([:contact])
  end

  def email_changeset(%User{contact: contact}, attrs) do
    contact
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end

  @impl true
  def fetch(id) do
    fetch(User, id)
  end

  @impl true
  def fetch_by(params) do
    fetch_by(User, params)
  end

  def fetch_by_email(email) do
    query =
      from u in User,
        left_join: c in assoc(u, :contact),
        where: fragment("lower(?)", c.email) == ^email,
        where: u.active?,
        order_by: [desc: u.inserted_at],
        limit: 1

    query
    |> Database.one()
    |> Fuschia.Helpers.maybe()
  end

  @impl true
  def insert(%User{} = user) do
    user
    |> changeset()
    |> Database.insert()
  end

  def insert_researcher(%User{} = user) do
    user
    |> changeset()
    |> put_change(:role, "pesquisador")
    |> password_changeset()
    |> Database.insert()
  end

  def insert_admin(%User{} = user) do
    user
    |> changeset()
    |> put_change(:role, "admin")
    |> Database.insert()
  end

  def password_changeset(user, attrs \\ %{}, opts \\ []) do
    user
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

  @impl true
  def update(%User{} = user) do
    values = Map.take(user, @update_fields)

    %User{id: user.id}
    |> cast(values, @update_fields)
    |> validate_inclusion(:role, @valid_roles)
    |> Database.update()
  end
end
