defmodule Fuschia.Entities.Contato do
  @moduledoc """
  Contato schema
  """

  use Fuschia.Schema

  import Ecto.Changeset

  alias Fuschia.Common.Formats

  @required_fields ~w(email endereco celular)a

  @mobile_format Formats.mobile()

  schema "contato" do
    field :celular, :string
    field :email, :string
    field :endereco, :string

    timestamps()
  end

  @doc false
  def changeset(contato, attrs) do
    contato
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:celular, @mobile_format)
    |> validate_email()
  end

  @doc """
  A contact changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(contact, attrs) do
    contact
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  defp validate_email(changeset) do
    changeset
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Fuschia.Repo)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      Fuschia.Encoder.encode(
        %{
          id: struct.id,
          celular: struct.celular,
          email: struct.email,
          endereco: struct.endereco
        },
        opts
      )
    end
  end
end
