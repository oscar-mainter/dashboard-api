defmodule DashboardApiWeb.DashboardCardController do
  use DashboardApiWeb, :controller

  action_fallback DashboardApiWeb.ErrorController

  alias DashboardApi.Dashboards.Dashboards

  plug DashboardApiWeb.Plugs.ValidateBody, fields: [:x, :y, :w, :h], only: [:create]


  def create(conn, params) do
    attrs = Map.take(params, ["x", "y", "w", "h", "system_id", "dashboard_id"])

    with {:ok, card} <- Dashboards.create_dashboard_card(attrs) do
      conn
      |> put_status(:created)
      |> put_view(DashboardApiWeb.Views.DashboardCardJSON)
      |> render("show.json", %{card: card})
    end
  end

  def update(conn, %{"dashboard_card_id" => dashboard_card_id} = params) do
    attrs = Map.take(params,["x", "y", "w", "h"])

    with {:ok, card} <- Dashboards.update_dashboard_card(dashboard_card_id, attrs) do
      conn
      |> put_view(DashboardApiWeb.Views.DashboardCardJSON)
      |> render("show.json", %{card: card})
    end
  end

  def delete(conn, %{"dashboard_card_id" => dashboard_card_id}) do
    with {:ok, _card} <- Dashboards.delete_dashboard_card(dashboard_card_id, %{}) do
      conn
      |> send_resp(:no_content, "")
    end

  end
end
