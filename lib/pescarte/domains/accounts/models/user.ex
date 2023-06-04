defmodule Pescarte.Domains.Accounts.Models.User do
  use Pescarte, :model

  import Brcpfcnpj.Changeset, only: [validate_cpf: 3]

  alias Pescarte.Domains.Accounts.Models.Contato
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @type t :: %User{
          id: integer,
          cpf: binary,
          confirmado_em: NaiveDateTime.t(),
          hash_senha: binary,
          data_nascimento: Date.t(),
          tipo: atom,
          primeiro_nome: binary,
          sobrenome: binary,
          id_publico: binary,
          ativo?: boolean,
          pesquisador: Pesquisador.t(),
          contato: Contato.t()
        }

  @valid_roles ~w(pesquisador pescador admin)a

  @required_fields ~w(primeiro_nome sobrenome cpf data_nascimento contato_id tipo)a
  @optional_fields ~w(confirmado_em)a

  @lower_pass_format ~r/[a-z]/
  @upper_pass_format ~r/[A-Z]/
  @special_pass_format ~r/[!?@#$%^&*_0-9]/

  schema "usuario" do
    field :cpf, :string
    field :confirmado_em, :naive_datetime
    field :hash_senha, :string, redact: true
    field :senha, :string, virtual: true, redact: true
    field :data_nascimento, :date
    field :tipo, Ecto.Enum, values: @valid_roles
    field :primeiro_nome, :string
    field :sobrenome, :string
    field :id_publico, :string
    field :ativo?, :boolean, default: false

    has_one :pesquisador, Pesquisador, foreign_key: :usuario_id
    belongs_to :contato, Contato, on_replace: :update

    timestamps()
  end

  @spec changeset(Usert.t(), map) :: Result.t(User.t(), changeset)
  def changeset(user \\ %User{}, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_cpf(:cpf, message: "CPF inválido")
    |> unique_constraint(:cpf)
    |> put_change(:id_publico, Nanoid.generate())
    |> apply_action(:parse)
  end

  @spec confirm_changeset(User.t(), NaiveDateTime.t()) :: changeset
  def confirm_changeset(%__MODULE__{} = user, now) do
    change(user, confirmado_em: now)
  end

  @spec password_changeset(User.t() | changeset, map, keyword) :: changeset
  def password_changeset(source, attrs \\ %{}, opts \\ []) do
    source
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
    hash_password? = Keyword.get(opts, :hash, true)
    password = get_change(changeset, :senha)

    if hash_password? && password && changeset.valid? do
      changeset
      |> validate_length(:senha, max: 72, count: :bytes)
      |> put_change(:hash_senha, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:senha)
    else
      changeset
    end
  end

  def user_roles, do: @valid_roles
end
