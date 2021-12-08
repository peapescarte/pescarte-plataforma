defmodule Fuschia.AuthLogFactory do
  @moduledoc false

  alias Fuschia.Entities.AuthLog

  defmacro __using__(_opts) do
    quote do
      @spec auth_log_factory :: AuthLog.t()
      def auth_log_factory do
        user_agent =
          "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"

        %AuthLog{
          ip: "127.0.0.1",
          user_agent: user_agent,
          user_cpf: 1
        }
      end
    end
  end
end
