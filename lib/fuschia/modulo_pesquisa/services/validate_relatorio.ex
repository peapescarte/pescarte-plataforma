defmodule Fuschia.ModuloPesquisa.Services.Relatorio do
  @moduledoc false

  use Fuschia, :domain_service

  import Ecto.Changeset, only: [cast: 3, add_error: 3, get_field: 2]

  def validate_month(report, field) do
    changeset = cast(report, %{}, [:mes])

    month = 1..12

    mth = get_field(changeset, field)

    if mth in month do
      {:ok, changeset}
    else
      {:error, add_error(changeset, field, "invalid month")}
    end
  end

  def validate_year(report, today, field) do
    changeset = cast(report, %{}, [:ano])

    year = get_field(changeset, field)

    if year <= today.year do
      {:ok, changeset}
    else
      {:error, add_error(changeset, field, "invalid year")}
    end
  end
end
