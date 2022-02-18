defmodule FuschiaWeb.V1.UserAgentTest do
  @moduledoc false

  use FuschiaWeb.ConnCase, async: true

  alias FuschiaWeb.UserAgent

  @moduletag :integration

  @user_agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "user-agent", @user_agent)}
  end

  describe "get/1" do
    test "get request header", %{conn: conn} do
      assert UserAgent.get(conn) == @user_agent
    end
  end
end
