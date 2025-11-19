# test/dashboard_api_web/controllers/dashboard_controller_test.exs
defmodule DashboardApiWeb.DashboardControllerTest do
  use DashboardApiWeb.ConnCase, async: true
  import DashboardApi.Fixtures

  alias DashboardApi.Repo
  alias DashboardApi.Dashboards.Dashboard

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create dashboard" do
    setup do
      system = fixture(:system)
      user   = fixture(:user, %{system: system})
      %{system: system, user: user}
    end

    test "success", %{conn: conn, system: system, user: user} do
      conn = post(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards", %{
        name: "My Dashboard"
      })

      assert %{"id" => id, "name" => "My Dashboard"} = json_response(conn, 201)["data"]
      assert Repo.get(Dashboard, id)
    end

    test "fails without name", %{conn: conn, system: system, user: user} do
      conn = post(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards", %{})

      assert json_response(conn, 422)["error"] == "Missing required fields"
    end
  end

  describe "index dashboards" do
    setup do
      system = fixture(:system)
      user = fixture(:user, %{system: system})

      fixture(:dashboard, %{system: system, user: user, name: "First"})
      fixture(:dashboard, %{system: system, user: user, name: "Second"})

      %{system: system, user: user}
    end

    test "without cards", %{conn: conn, system: system, user: user} do
      conn = get(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards")
      assert %{"data" => dashboards} = json_response(conn, 200)
      assert length(dashboards) == 2
    end

    test "with cards=true", %{conn: conn, system: system, user: user} do

      conn = get(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards?cards=true")
      assert %{"data" => [dash | _]} = json_response(conn, 200)
      assert is_list(dash["cards"])
    end
  end

  describe "show dashboard" do
    setup do
      system = fixture(:system)
      user = fixture(:user, %{system: system})
      dashboard = fixture(:dashboard, %{system: system, user: user})
      %{system: system, user: user, dashboard: dashboard}
    end

    test "success", %{conn: conn, system: system, user: user, dashboard: dashboard} do
      conn = get(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards/#{dashboard.id}")

      response_data = json_response(conn, 200)["data"]
      assert response_data["id"] == dashboard.id
    end

    test "not found", %{conn: conn, system: system, user: user} do
      conn = get(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards/999999")
      assert json_response(conn, 404)["error"] == "Not found"
    end
  end

  describe "delete dashboard" do
    setup do
      system   = fixture(:system)
      user     = fixture(:user, %{system: system})
      dashboard = fixture(:dashboard, %{system: system, user: user})
      %{system: system, user: user, dashboard: dashboard}
    end

    test "success", %{conn: conn, system: system, user: user, dashboard: dashboard} do
      conn = delete(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards/#{dashboard.id}")
      assert response(conn, 204)
      refute Repo.get(Dashboard, dashboard.id)
    end
  end
end
