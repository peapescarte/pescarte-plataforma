defmodule FuschiaWeb.FuschiaViewTest do
  use FuschiaWeb.ConnCase, async: true

  import Phoenix.View

  alias FuschiaWeb.FuschiaView

  @moduletag :integration

  test "renders response.json" do
    data = %{test: true}
    assert render(FuschiaView, "response.json", %{data: data}) == %{data: %{test: true}}
  end

  test "renders paginated.json" do
    response = %{data: [%{test: true}], pagination: %{test: true}}

    assert render(FuschiaView, "paginated.json", response) == %{
             data: [%{test: true}],
             pagination: %{test: true}
           }
  end
end
