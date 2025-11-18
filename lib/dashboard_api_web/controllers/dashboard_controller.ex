defmodule DashboardApiWeb.DashboardController do
  use DashboardApiWeb, :controller

  action_fallback DashboardApiWeb.ErrorController

  alias DashboardApi.Dashboards.Dashboards

  plug DashboardApiWeb.Plugs.ValidateBody, fields: [:name], only: [:create]

  def create(conn, params) do
    attrs = Map.take(params, ["name", "system_id", "user_id"])

    with {:ok, dashboard} <- Dashboards.create_dashboard(attrs) do
      conn
      |> put_status(:created)
      |> put_view(DashboardApiWeb.Views.DashboardWithCardsJSON)
      |> render(:show, %{dashboard: dashboard})
    end
  end

  def index(conn, %{"system_id" => system_id, "user_id" => user_id} = params) do
    view =
      if params["cards"] == "true",
        do: DashboardApiWeb.Views.DashboardWithCardsJSON,
        else: DashboardApiWeb.Views.DashboardJSON

      dashboards =
        if view == DashboardApiWeb.Views.DashboardWithCardsJSON,
          do: Dashboards.list_dashboards_with_cards(system_id, user_id),
          else: Dashboards.list_dashboards(system_id, user_id)

      conn
      |> put_view(view)
      |> render("index.json", %{dashboards: dashboards})
  end


  def show(conn, %{"dashboard_id" => dashboard_id}) do
    with {:ok, dashboard} <- Dashboards.get_dashboard(dashboard_id) do
      conn
      |> put_view(DashboardApiWeb.Views.DashboardJSON)
      |> render("show.json", %{dashboard: dashboard})
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"dashboard_id" => dashboard_id}) do
    with {:ok, _dashboard} <- Dashboards.delete_dashboard(dashboard_id) do
      conn
      |> send_resp(:no_content, "")
    end
  end
end
