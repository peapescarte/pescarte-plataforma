defmodule Pescarte.Identidades.Models.Contato do
  use Pescarte, :model

  alias Pescarte.Database.Types.PublicId

  @type t :: %Contato{
          email_principal: binary,
          celular_principal: binary,
          emails_adicionais: list(binary),
          celulares_adicionais: list(binary),
          endereco: String.t(),
          id: binary
        }

  # endereco_id)a
  @optional_fields ~w(emails_adicionais celulares_adicionais)a
  @required_fields ~w(email_principal celular_principal endereco)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "contato" do
    field :celular_principal, :string
    field :emails_adicionais, {:array, :string}
    field :celulares_adicionais, {:array, :string}
    field :email_principal, :string
    field :endereco, :string

    timestamps()
  end

  @spec changeset(Contato.t(), map) :: changeset
  def changeset(%Contato{} = contato, attrs) do
    contato
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required([:email_principal, :celular_principal, :endereco])
    |> unique_constraint(:email_principal)
    |> validate_change(:emails_adicionais, &validate_duplicates/2)
    |> validate_change(:celulares_adicionais, &validate_duplicates/2)
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
