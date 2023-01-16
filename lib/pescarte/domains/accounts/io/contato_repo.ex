defmodule Pescarte.Domains.Accounts.IO.ContatoRepo do
  use Pescarte, :repo

  alias Pescarte.Domains.Accounts.Models.Contato
  alias Pescarte.Common.Formats

  @email_format Formats.email()
  @mobile_format Formats.mobile()

  @fields ~w(mobile email address)a

  def changeset(%Contato{} = contato, attrs \\ %{}) do
    contato
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_format(:mobile, @mobile_format)
    |> validate_length(:email, max: 160)
    |> validate_format(:email, @email_format)
    |> unsafe_validate_unique(:email, Pescarte.Repo)
    |> unique_constraint(:email)
  end

  @impl true
  def fetch(id) do
    fetch(Contato, id)
  end

  @impl true
  def insert_or_update(attrs) do
    %Contato{}
    |> changeset(attrs)
    |> Database.insert_or_update()
  end
end
