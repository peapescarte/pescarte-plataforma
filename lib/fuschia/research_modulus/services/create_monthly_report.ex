defmodule Fuschia.ResearchModulus.Services.CreateMonthlyReport do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.MonthlyReportRepo
  alias Fuschia.ResearchModulus.Models.MonthlyReport

  @impl true
  def process(params) do
    params
    |> MonthlyReport.new()
    |> MonthlyReportRepo.insert()
  end
end
