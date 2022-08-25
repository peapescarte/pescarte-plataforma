defmodule Fuschia.Accounts.IO.ContatoRepo do
  @moduledoc false
  use Fuschia, :repo

  alias Fuschia.Accounts.Models.Contato
  alias Fuschia.Common.Formats

  @email_format Formats.email()
  @mobile_format Formats.mobile()

  @fields ~w(celular email endereco)a

  @impl true
  def fetch(id) do
    fetch(Contato, id)
  end

  @impl true
  def insert_or_update(%Contato{} = contact) do
    contact
    |> cast(%{}, @fields)
    |> validate_required(@fields)
    |> validate_format(:celular, @mobile_format)
    |> validate_length(:email, max: 160)
    |> validate_format(:email, @email_format)
    |> unsafe_validate_unique(:email, Fuschia.Repo)
    |> unique_constraint(:email)
    |> Database.insert_or_update()
  end
end
