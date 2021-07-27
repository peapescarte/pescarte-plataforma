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

  defmodule Parser do
    @moduledoc """
    Defines the contract to parse custom attributes
    """

    @doc """
    Parses the given `map` with nested ids in order to conform to current schema definition.

    ## Examples

        iex> parse_nested_ids(%{"linha_pesquisa" => %{"id" => 1}, "pesquisador_id" => 2})
        %{"linha_pesquisa" => %{"id" => 1}, "linha_pesquisa_id" => 1, "pesquisador_id" => 2}

    """
    @callback parse_nested_ids(map) :: map

    @spec reject_empty(map) :: map
    def reject_empty(attrs) do
      attrs
      |> Enum.reject(fn {_, v} -> is_nil(v) end)
      |> Enum.into(%{})
    end
  end
end
