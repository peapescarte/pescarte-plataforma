defmodule FuschiaWeb.MonthlyReportView do
  use FuschiaWeb, :view

  @today Date.utc_today()

  @months %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }

  def get_current_month do
    Map.get(@months, to_string(@today.month))
  end

  def get_current_year do
    @today.year
  end
end
