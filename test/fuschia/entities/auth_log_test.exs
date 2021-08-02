defmodule Fuschia.Entities.AuthLogTest do
  use Fuschia.DataCase, async: true

  alias Fuschia.Entities.AuthLog

  describe "changeset/2" do
    setup do
      %{
        ip: "127.0.0.1",
        user_agent: "Mozilla/5.0",
        user_cpf: "665.171.560-70"
      }
    end

    test "when all params are valid, return a valid changeset", default_params do
      assert %{} == errors_on(AuthLog.changeset(%AuthLog{}, default_params))
    end

    test "ip must be required", default_params do
      params = Map.delete(default_params, :ip)

      assert %{ip: ["can't be blank"]} = errors_on(AuthLog.changeset(%AuthLog{}, params))
    end

    test "user_agent must be required", default_params do
      params = Map.delete(default_params, :user_agent)

      assert %{user_agent: ["can't be blank"]} = errors_on(AuthLog.changeset(%AuthLog{}, params))
    end

    test "user_cpf must be required", default_params do
      params = Map.delete(default_params, :user_cpf)

      assert %{user_cpf: ["can't be blank"]} = errors_on(AuthLog.changeset(%AuthLog{}, params))
    end
  end
end
