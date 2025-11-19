defmodule DashboardApiWeb.DashboardCardControllerTest do
  use DashboardApiWeb.ConnCase, async: true
  import DashboardApi.Fixtures

  alias DashboardApi.Repo
  alias DashboardApi.Dashboards.DashboardCard

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "dashboard cards" do
    setup do
      system = fixture(:system)
      user = fixture(:user, %{system: system})
      dashboard = fixture(:dashboard, %{system: system, user: user})

      %{system: system, user: user, dashboard: dashboard}
    end

    test "create: success", %{conn: conn, system: system, user: user, dashboard: dashboard} do
      conn =
        post(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards/#{dashboard.id}/cards", %{
          x: 0,
          y: 0,
          w: 4,
          h: 4,
          system_id: system.id,
          dashboard_id: dashboard.id
        })

        assert %{"id" => id} = json_response(conn, 201)["data"]
        assert Repo.get(DashboardCard, id)
    end

    test "create: missing required fields", %{conn: conn, system: system, user: user, dashboard: dashboard} do
      conn =
        post(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards/#{dashboard.id}/cards", %{})

        assert json_response(conn, 422)["error"] == "Missing required fields"
    end

    test "create: invalid numbers", %{conn: conn, system: system, user: user, dashboard: dashboard} do
      conn =
        post(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards/#{dashboard.id}/cards", %{
          x: -1, y: -1, w: 0, h: 0,
          system_id: system.id,
          dashboard_id: dashboard.id
        })

        errors = json_response(conn, 422)["errors"]

        assert errors["x"] == ["x must be greater than or equal to 0"]
        assert errors["y"] == ["y must be greater than or equal to 0"]
        assert errors["w"] == ["w must be greater than 0"]
        assert errors["h"] == ["h must be greater than 0"]
    end

    test "update: success", %{conn: conn, system: system, user: user, dashboard: dashboard} do
      card = fixture(:dashboard_card, %{dashboard: dashboard})

      conn =
        patch(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards/#{dashboard.id}/cards/#{card.id}", %{
          x: 10,
          y: 20,
        })

        assert %{"id" => id} = json_response(conn, 200)["data"]
        assert Repo.get(DashboardCard, id)
    end

    test "update: invalid numbers", %{conn: conn, system: system, user: user, dashboard: dashboard} do
      card = fixture(:dashboard_card, %{dashboard: dashboard})

      conn =
        patch(conn, ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards/#{dashboard.id}/cards/#{card.id}", %{
          w: 0,
          h: 0,
        })

      errors = json_response(conn, 422)["errors"]

      assert errors["w"] == ["w must be greater than 0"]
      assert errors["h"] == ["h must be greater than 0"]
    end

    test "delete: success", %{conn: conn, system: system, user: user, dashboard: dashboard} do
      card = fixture(:dashboard_card, %{dashboard: dashboard})

      conn =
        delete(conn,
          ~p"/api/v1/systems/#{system.id}/users/#{user.id}/dashboards/#{dashboard.id}/cards/#{card.id}"
        )

      assert response(conn, 204)
      refute Repo.get(DashboardCard, card.id)
    end

    test "cannot create card on someone else's dashboard", %{conn: conn, system: system} do
      owner = fixture(:user, %{system: system})
      thief = fixture(:user, %{system: system})
      dashboard = fixture(:dashboard, %{system: system, user: owner})

      conn =
        post(conn,
          ~p"/api/v1/systems/#{system.id}/users/#{thief.id}/dashboards/#{dashboard.id}/cards",
          %{x: 0, y: 0, w: 4, h: 4, system_id: system.id, dashboard_id: dashboard.id}
        )

        assert json_response(conn, 403)
    end

    test "cannot update someone else's card", %{conn: conn, system: system} do
      owner = fixture(:user, %{system: system})
      thief = fixture(:user, %{system: system})
      dashboard = fixture(:dashboard, %{system: system, user: owner})
      card = fixture(:dashboard_card, %{dashboard: dashboard})

      conn =
        patch(conn,
          ~p"/api/v1/systems/#{system.id}/users/#{thief.id}/dashboards/#{dashboard.id}/cards/#{card.id}",
          %{x: 12}
        )

      assert json_response(conn, 403)
    end

    test "cannot delete someone else's card", %{conn: conn, system: system} do
      owner = fixture(:user, %{system: system})
      thief = fixture(:user, %{system: system})
      dashboard = fixture(:dashboard, %{system: system, user: owner})
      card = fixture(:dashboard_card, %{dashboard: dashboard})

      conn =
        delete(conn,
          ~p"/api/v1/systems/#{system.id}/users/#{thief.id}/dashboards/#{dashboard.id}/cards/#{card.id}"
        )

      assert json_response(conn, 403)
    end
  end
end
