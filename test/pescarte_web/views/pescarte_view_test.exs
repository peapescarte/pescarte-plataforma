defmodule PescarteWeb.PescarteViewTest do
  use PescarteWeb.ConnCase, async: true

  import Phoenix.View

  alias PescarteWeb.PescarteView

  @moduletag :integration

  test "renders response.json" do
    data = %{test: true}
    assert render(PescarteView, "response.json", %{data: data}) == %{data: %{test: true}}
  end

  test "renders paginated.json" do
    response = %{data: [%{test: true}], pagination: %{test: true}}

    assert render(PescarteView, "paginated.json", response) == %{
             data: [%{test: true}],
             pagination: %{test: true}
           }
  end
end
