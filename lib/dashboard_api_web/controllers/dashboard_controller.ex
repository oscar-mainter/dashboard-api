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

  def index(conn, %{"system_id" => system_id, "user_id" => user_id} = params) do
    {dashboards, view} =
      case params["cards"] do
        "true" ->
          {Dashboards.list_dashboards_with_cards(system_id, user_id), DashboardApiWeb.Views.DashboardWithCardsJSON}

        _ ->
          {Dashboards.list_dashboards(system_id, user_id), DashboardApiWeb.Views.DashboardJSON}
      end

    conn
    |> put_view(view)
    |> render("index.json", %{dashboards: dashboards})
  end



  def show(conn, %{"dashboard_id" => dashboard_id}) do
    dashboard_id = dashboard_id

    case Dashboards.get_dashboard(dashboard_id) do
      {:ok, dashboard} ->
        conn
        |> put_view(DashboardApiWeb.Views.DashboardWithCardsJSON)
        |> render("show.json", dashboard: dashboard)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(:error, message: "Dashboard not found")
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"dashboard_id" => dashboard_id}) do
    dashboard_id = dashboard_id

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
