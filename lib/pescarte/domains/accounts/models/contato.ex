defmodule Pescarte.Domains.Accounts.Models.Contato do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.Endereco


  @fields ~w(emails_adicionais celulares_adicionais endereco_id)a

  @required_fields ~w(email_principal celular_principal)a

  # apenas pra forçar formatação do campo
  # a validação de um email é feita de forma
  # mais complexa no front
  @email_format ~r/[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+/
  @mobile_format ~r/\(\d{2}\)\d{5}-\d{4}/

  schema "contato" do
    field :email_principal, :string
    field :celular_principal, :string
    field :emails_adicionais, {:array, :string}
    field :celulares_adicionais, {:array, :string}

    belongs_to :endereco, Endereco

    timestamps()
  end

  def changeset(contato \\ %__MODULE__{}, attrs) do
    contato
    |> cast(attrs, @fields ++ @required_fields)
    |> validate_required([:email_principal, :celular_principal])
    |> validate_length(:email_principal, max: 160)
    |> validate_format(:email_principal, @email_format)
    |> validate_format(:celular_principal, @mobile_format)
    |> unsafe_validate_unique(:email_principal, Pescarte.Repo)
    |> unique_constraint(:email_principal)
    |> validate_change(:emails_adicionais, &validate_emails_format/2)
    |> validate_change(:celulares_adicionais, &validate_celulares_format/2)
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

  defp validate_emails_format(_field, values) do
    errors = Enum.reject(values, &Regex.match?(@email_format, &1))

    if Enum.empty?(errors) do
      []
    else
      error = Enum.join(errors, ",")
      [emails_adicionais: "formato inválido para os emails: #{error}"]
    end
  end

  defp validate_celulares_format(_field, values) do
    errors = Enum.reject(values, &Regex.match?(@mobile_format, &1))

    if Enum.empty?(errors) do
      []
    else
      error = Enum.join(errors, ",")
      [celulares_adicionais: "formato inválido para os celulares: #{error}"]
    end
  end
end
