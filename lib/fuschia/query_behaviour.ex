defmodule Fuschia.Query do
  @moduledoc """
  Define funções públicas que devem ser implementadas
  em módulos de `Queries`
  """

  @callback query :: Ecto.Query.t()

  @callback relationships :: keyword
end
