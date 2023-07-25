defmodule DesignSystem do
  @moduledoc false

  alias DesignSystem.Components

  defdelegate text(assigns), to: Components.Text, as: :render
end
