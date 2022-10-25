defmodule PescarteWeb.LayoutView do
  use PescarteWeb, :view

  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}
end
