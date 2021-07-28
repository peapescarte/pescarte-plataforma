defmodule Fuschia.Schema do
  @moduledoc """
  Default schema for Fuschia
  """

  import FuschiaWeb.Gettext

  @doc false
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Fuschia.Schema, only: [validate_foreign_key: 3]

      @timestamps_opts [inserted_at: :created_at, type: :utc_datetime_usec]
    end
  end

  @doc """
  Validates foreign keys using the respective `context` and `field_name`.

  This function is meant to be used on embedded schemas that require this
  type of manual constraint check.

  ## Examples

      iex> Fuschia.Schema.validate_foreign_key(changeset, Fuschia.LinhasPesquisas, :linha_pesquisa_id)
      #Ecto.Changeset<
        action: nil,
        changes: %{some_change: "some_value"}
      }
  """
  @spec validate_foreign_key(Ecto.Changeset.t(), module, atom) :: Ecto.Changeset.t()
  def validate_foreign_key(changeset, context, field_name) do
    with field_id when not is_nil(field_id) <- Ecto.Changeset.get_field(changeset, field_name),
         nil <- context.one(field_id) do
      Ecto.Changeset.add_error(
        changeset,
        field_name,
        dgettext("errors", "does not exist")
      )
    else
      _ ->
        changeset
    end
  end
end
