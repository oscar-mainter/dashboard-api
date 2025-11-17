defmodule DashboardApiWeb.PageController do
    use DashboardApiWeb, :controller

    def index(conn, _params) do
      conn
      |> json(%{message: "Welcome to the Dashboard API"})
    end

    def not_found(conn, _params) do
      conn
      |> put_status(:not_found)
      |> json(%{error: "Route not found"})
    end

end
