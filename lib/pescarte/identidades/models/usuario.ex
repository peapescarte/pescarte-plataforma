defmodule Pescarte.Identidades.Models.Usuario do
  use Pescarte, :model

  import Brcpfcnpj.Changeset, only: [validate_cpf: 3]

  alias Pescarte.Identidades.Models.Contato
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @type t :: %Usuario{
          cpf: binary,
          rg: binary,
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

  @required_fields ~w(primeiro_nome sobrenome cpf data_nascimento contato_email tipo)a
  @optional_fields ~w(confirmado_em rg)a

  @lower_pass_format ~r/[a-z]/
  @upper_pass_format ~r/[A-Z]/
  @special_pass_format ~r/[!?@#$%^&*_0-9]/

  @primary_key {:id_publico, PublicId, autogenerate: true}
  schema "usuario" do
    field :cpf, :string
    field :rg, :string
    field :confirmado_em, :naive_datetime
    field :hash_senha, :string, redact: true
    field :senha, :string, virtual: true, redact: true
    field :data_nascimento, :date
    field :tipo, Ecto.Enum, values: @valid_roles
    field :primeiro_nome, :string
    field :sobrenome, :string
    field :ativo?, :boolean, default: false

    has_one :pesquisador, Pesquisador,
      references: :id_publico,
      foreign_key: :usuario_id

    belongs_to :contato, Contato,
      foreign_key: :contato_email,
      references: :email_principal,
      on_replace: :update,
      type: :string

    timestamps()
  end

  @spec changeset(Usuario.t(), map) :: changeset
  def changeset(%Usuario{} = user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_cpf(:cpf, message: "CPF inválido")
    |> unique_constraint(:cpf)
  end

  @spec confirm_changeset(Usuario.t(), NaiveDateTime.t()) :: changeset
  def confirm_changeset(%__MODULE__{} = user, now) do
    change(user, confirmado_em: now)
  end

  @spec password_changeset(Usuario.t() | changeset, map, keyword) :: changeset
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
