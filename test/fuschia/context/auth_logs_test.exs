defmodule Fuschia.AuthLogsTest do
  @moduledoc false

  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Context.AuthLogs
  alias Fuschia.Entities.AuthLog
  alias Fuschia.Repo

  @ip "127.0.0.1"

  describe "create/1" do
    test "success should return :ok" do
      ua =
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"

      user = insert(:user)

      result = AuthLogs.create(%{"ip" => @ip, "user_agent" => ua, "user_cpf" => user.cpf})
      auth_log = get_log(@ip)

      assert result == :ok
      assert Map.get(auth_log, :ip) == @ip
      assert Map.get(auth_log, :user_agent) == ua
      assert Map.get(auth_log, :user_cpf) == user.cpf
    end

    test "with error should return :ok" do
      user = build(:user)
      result = AuthLogs.create(%{"user_cpf" => user})
      auth_log = get_log(@ip)

      assert result == :ok
      assert auth_log == nil
    end
  end

  describe "create/3" do
    test "success should return :ok" do
      ua =
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"

      user = insert(:user)

      result = AuthLogs.create(@ip, ua, user)
      auth_log = get_log(@ip)

      assert result == :ok
      assert Map.get(auth_log, :ip) == @ip
      assert Map.get(auth_log, :user_agent) == ua
      assert Map.get(auth_log, :user_cpf) == user.cpf
    end

    test "with error should return :ok" do
      user = build(:user)
      result = AuthLogs.create(nil, nil, user)
      auth_log = get_log(@ip)

      assert result == :ok
      assert auth_log == nil
    end
  end

  defp get_log(ip) do
    Repo.get_by(AuthLog, ip: ip)
  end
end
