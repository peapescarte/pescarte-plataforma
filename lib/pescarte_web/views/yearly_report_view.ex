defmodule PescarteWeb.YearlyReportView do
  use PescarteWeb, :view

  @today Date.utc_today()

  def get_current_year do
    @today.year
  end
end
