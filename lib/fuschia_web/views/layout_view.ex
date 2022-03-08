defmodule FuschiaWeb.LayoutView do
  use FuschiaWeb, :view

  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}
end
