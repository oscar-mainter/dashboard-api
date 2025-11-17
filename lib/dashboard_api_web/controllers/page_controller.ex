defmodule DashboardApiWeb.PageController do
    use DashboardApiWeb, :controller

    def index(conn, _params) do
      conn
      |> json(%{message: "Welcome to the Dashboard API"})
    end
end
