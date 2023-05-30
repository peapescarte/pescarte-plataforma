defmodule Pescarte.Domains.Accounts.Models.Contato do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.Endereco

  @opaque t :: %Contato{
            id: integer,
            email_principal: binary,
            celular_principal: binary,
            emails_adicionais: list(binary),
            celulares_adicionais: list(binary),
            endereco: Endereco.t()
          }

  @optional_fields ~w(emails_adicionais celulares_adicionais endereco_id)a
  @required_fields ~w(email_principal celular_principal)a

  schema "contato" do
    field :email_principal, :string
    field :celular_principal, :string
    field :emails_adicionais, {:array, :string}
    field :celulares_adicionais, {:array, :string}

    belongs_to :endereco, Endereco

    timestamps()
  end

  @spec changeset(map) :: Result.t(Contato.t(), changeset)
  def changeset(contato \\ %__MODULE__{}, attrs) do
    contato
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required([:email_principal, :celular_principal])
    |> unsafe_validate_unique(:email_principal, Pescarte.Repo)
    |> unique_constraint(:email_principal)
    |> validate_change(:emails_adicionais, &validate_duplicates/2)
    |> validate_change(:celulares_adicionais, &validate_duplicates/2)
    |> apply_action(:parse)
  end

  defp validate_duplicates(field, values) do
    duplicates = values -- Enum.uniq(values)

    if Enum.empty?(duplicates) do
      []
    else
      error = Enum.join(duplicates, ",")
      [{field, "valores duplicados: #{error}"}]
    end
  end
end
