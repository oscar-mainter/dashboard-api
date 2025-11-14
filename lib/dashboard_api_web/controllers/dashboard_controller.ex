defmodule DashboardApiWeb.DashboardController do
  use DashboardApiWeb, :controller

  alias DashboardApi.Dashboards.Dashboards

  def create(conn, %{"name" => name} = params) do
    attrs = %{
      "name" => name,
      "system_id" => params["system_id"],
      "user_id" => params["user_id"]
    }

    case Dashboards.create_dashboard(attrs) do
      {:ok, dashboard} ->
        conn
        |> put_status(:created)
        |> render(:show, dashboard: dashboard)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset:  changeset)
    end
  end

  def index(conn, params) do
    system_id = String.to_integer(params["system_id"])
    user_id = String.to_integer(params["user_id"])

    dashboards = Dashboards.list_dashboards(system_id, user_id)

    conn
    |> render(:index, dashboards: dashboards)
  end

  def show(conn, %{"dashboard_id" => dashboard_id}) do
    dashboard_id = String.to_integer(dashboard_id)

    case Dashboards.get_dashboard(dashboard_id) do
      {:ok, dashboard} ->
        conn
        |> render(:show, dashboard: dashboard)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(:error, message: "Dashboard not found")
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"dashboard_id" => dashboard_id}) do
    dashboard_id = String.to_integer(dashboard_id)

    case Dashboards.delete_dashboard(dashboard_id) do
      {:ok, _dashboard} ->
        conn
        |> put_status(:no_content)
        |> send_resp(:no_content, "")
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(:error, message: "Dashboard not found")
     end
  end
end
