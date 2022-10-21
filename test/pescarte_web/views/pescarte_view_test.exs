defmodule BackendWeb.BackendViewTest do
  use BackendWeb.ConnCase, async: true

  import Phoenix.View

  alias BackendWeb.BackendView

  @moduletag :integration

  test "renders response.json" do
    data = %{test: true}
    assert render(BackendView, "response.json", %{data: data}) == %{data: %{test: true}}
  end

  test "renders paginated.json" do
    response = %{data: [%{test: true}], pagination: %{test: true}}

    assert render(BackendView, "paginated.json", response) == %{
             data: [%{test: true}],
             pagination: %{test: true}
           }
  end
end
