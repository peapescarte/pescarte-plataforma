defmodule Pescarte.ResearchModulus.Services.GetQuarterlyReport do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.QuarterlyReportRepo

  def process do
    QuarterlyReportRepo.all()
  end

  @impl true
  def process(id: id) do
    QuarterlyReportRepo.fetch(id)
  end
end
