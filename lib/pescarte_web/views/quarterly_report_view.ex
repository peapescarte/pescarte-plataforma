defmodule PescarteWeb.QuarterlyReportView do
  use PescarteWeb, :view

  @today Date.utc_today()

  @quarter %{
    "1" => "Primeiro",
    "2" => "Primeiro",
    "3" => "Primeiro",
    "4" => "Segundo",
    "5" => "Segundo",
    "6" => "Segundo",
    "7" => "Terceiro",
    "8" => "Terceiro",
    "9" => "Terceiro",
    "10" => "Quarto",
    "11" => "Quarto",
    "12" => "Quarto"
  }

  def get_current_quarter do
    Map.get(@quarter, to_string(@today.month))
  end

  def get_current_year do
    @today.year
  end
end
