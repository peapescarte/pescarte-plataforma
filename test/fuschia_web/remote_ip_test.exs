defmodule FuschiaWeb.RemoteIpTest do
  @moduledoc false

  use FuschiaWeb.ConnCase, async: true

  alias FuschiaWeb.RemoteIp

  @moduletag :integration

  @ip_v4 "3.220.149.180"
  @ip_v6 "2001:0db8:85a3:0000:0000:8a2e:0370:7334"

  setup %{conn: conn} do
    {:ok, conn: conn}
  end

  describe "get/1 CloudFlare Header" do
    test "Get Request IP v4", %{conn: conn} do
      conn = put_req_header(conn, "cf-connecting-ip", @ip_v4)

      assert RemoteIp.get(conn) == @ip_v4
    end

    test "Get request IP V4 with port", %{conn: conn} do
      conn = put_req_header(conn, "cf-connecting-ip", "#{@ip_v4}:7890")

      assert RemoteIp.get(conn) == @ip_v4
    end

    test "Get request IP V6", %{conn: conn} do
      conn = put_req_header(conn, "cf-connecting-ip", "[#{@ip_v6}]")

      assert RemoteIp.get(conn) == @ip_v6
    end

    test "Get request IP V6 with port", %{conn: conn} do
      conn = put_req_header(conn, "cf-connecting-ip", "[#{@ip_v6}]:7890")

      assert RemoteIp.get(conn) == @ip_v6
    end
  end

  describe "get/1 Forwarded For Header" do
    test "Get request IP v4", %{conn: conn} do
      conn = put_req_header(conn, "x-forwarded-for", @ip_v4)

      assert RemoteIp.get(conn) == @ip_v4
    end

    test "Get request IP V4 with port", %{conn: conn} do
      conn = put_req_header(conn, "x-forwarded-for", "#{@ip_v4}:7890")

      assert RemoteIp.get(conn) == @ip_v4
    end

    test "Get request IP V6", %{conn: conn} do
      conn = put_req_header(conn, "x-forwarded-for", "[#{@ip_v6}]")

      assert RemoteIp.get(conn) == @ip_v6
    end

    test "Get request IP V6 with port", %{conn: conn} do
      conn = put_req_header(conn, "x-forwarded-for", "[#{@ip_v6}]:7890")

      assert RemoteIp.get(conn) == @ip_v6
    end

    test "Get request IP V4 with more then one proxied IP", %{conn: conn} do
      conn = put_req_header(conn, "x-forwarded-for", "#{@ip_v4}, 127.0.0.1")

      assert RemoteIp.get(conn) == @ip_v4
    end
  end

  describe "get/1 Forwarded Header" do
    test "Get request IP v4", %{conn: conn} do
      conn = put_req_header(conn, "forwarded", "for=#{@ip_v4};proto=http;by=127.0.0.1")

      assert RemoteIp.get(conn) == @ip_v4
    end

    test "Get request IP V4 with port", %{conn: conn} do
      conn = put_req_header(conn, "forwarded", "for=#{@ip_v4}:7890;proto=http;by=127.0.0.1")

      assert RemoteIp.get(conn) == @ip_v4
    end

    test "Get request IP V6", %{conn: conn} do
      conn = put_req_header(conn, "forwarded", "for=\"[#{@ip_v6}]\"")

      assert RemoteIp.get(conn) == @ip_v6
    end

    test "Get request IP V6 with port", %{conn: conn} do
      conn = put_req_header(conn, "forwarded", "for=\"[#{@ip_v6}]:7890\"")

      assert RemoteIp.get(conn) == @ip_v6
    end
  end

  describe "get/1 remote_ip from header" do
    test "Get request IP v4", %{conn: conn} do
      conn = Map.put(conn, :remote_ip, {3, 220, 149, 180})

      assert RemoteIp.get(conn) == @ip_v4
    end
  end
end
