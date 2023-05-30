defmodule MonadsTest do
  use ExUnit.Case, async: true

  alias Monads.Maybe
  alias Monads.Result

  doctest Monads.Maybe
  doctest Monads.Result
end
