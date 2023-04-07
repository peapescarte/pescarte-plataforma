defmodule Pescarte.Domains.Accounts.IO.ContatoRepo do
  use Pescarte, :repo

  alias Pescarte.Domains.Accounts.Models.Contato

  @fields ~w(mobile email address)a

  def changeset(%Contato{} = contato, attrs \\ %{}) do
    contato
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:email, max: 160)
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
