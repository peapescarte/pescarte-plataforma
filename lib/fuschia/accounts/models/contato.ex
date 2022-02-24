defmodule Fuschia.Accounts.Models.Contato do
  @moduledoc """
  Contato schema
  """

  use Fuschia.Schema

  import Ecto.Changeset
  import FuschiaWeb.Gettext

  alias Fuschia.Common.Formats

  @required_fields ~w(email endereco celular)a

  @email_format Formats.email()
  @mobile_format Formats.mobile()

  schema "contato" do
    field :celular, :string
    field :email, :string
    field :endereco, :string

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(contato, attrs) do
    contato
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:celular, @mobile_format)
    |> validate_email()
  end

  @spec validate_email(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def validate_email(changeset) do
    changeset
    |> validate_length(:email,
      max: 160,
      message: dgettext("errors", "should be at most 160 character(s)", count: 160)
    )
    |> validate_format(:email, @email_format,
      message: dgettext("errors", "must have the @ sign and no spaces")
    )
    |> unsafe_validate_unique(:email, Fuschia.Repo)
    |> unique_constraint(:email)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    @spec encode(Fuschia.Entities.Contato.t(), map) :: map
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
