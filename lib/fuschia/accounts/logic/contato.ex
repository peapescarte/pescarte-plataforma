defmodule Fuschia.Accounts.Logic.Contato do
  @moduledoc false

  import Ecto.Changeset,
    only: [
      validate_length: 3,
      validate_format: 4,
      unsafe_validate_unique: 3,
      unique_constraint: 2
    ]

  import FuschiaWeb.Gettext

  alias Fuschia.Common.Formats

  @email_format Formats.email()

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
end
