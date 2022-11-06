defmodule Pescarte.ResearchModulus.Services.CreateQuarterlyReport do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.QuarterlyReportRepo

  @impl true
  def process(params) do
    QuarterlyReportRepo.insert(params)
  end
end
