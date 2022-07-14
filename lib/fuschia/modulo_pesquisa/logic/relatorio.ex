defmodule Fuschia.ModuloPesquisa.Logic.Relatorio do
  @moduledoc false

  import Ecto.Changeset, only: [add_error: 3, get_field: 2]

  def validate_month(changeset, field) do
    month = 1..12

    mth = get_field(changeset, field)

    if mth in month do
      changeset
    else
      add_error(changeset, field, "invalid month")
    end
  end

  def validate_year(changeset, field) do
    today = Date.utc_today()

    year = get_field(changeset, field)

    if year <= today.year do
      changeset
    else
      add_error(changeset, field, "invalid year")
    end
  end
end
