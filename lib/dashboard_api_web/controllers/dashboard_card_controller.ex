defmodule DashboardApiWeb.DashboardCardController do
  use DashboardApiWeb, :controller

  alias DashboardApi.Dashboards.Dashboards

  plug DashboardApiWeb.Plugs.ValidateBody, fields: [:x, :y, :w, :h], only: [:create]


  def create(conn, params) do
    attrs = %{
      "x" => params["x"],
      "y" => params["y"],
      "w" => params["w"],
      "h" => params["h"],
      "system_id" => params["system_id"],
      "dashboard_id" => params["dashboard_id"]
    }

    case Dashboards.create_dashboard_card(attrs) do
      {:ok, card} ->
        conn
        |> put_status(:created)
        |> put_view(DashboardApiWeb.Views.DashboardCardJSON)
        |> render("show.json", %{card: card})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(DashboardApiWeb.Views.DashboardCardJSON)
        |> render("error.json", changeset: changeset)
    end
  end

  def update(conn, %{"dashboard_card_id" => dashboard_card_id} = params) do

    update_attrs = %{
      "x" => params["x"],
      "y" => params["y"],
      "w" => params["w"],
      "h" => params["h"]
    }

    case Dashboards.update_dashboard_card(dashboard_card_id, update_attrs) do
      {:ok, card} ->
        conn
        |> put_view(DashboardApiWeb.Views.DashboardCardJSON)
        |> render("show.json", %{card: card})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(DashboardApiWeb.Views.DashboardCardJSON)
        |> render("error.json", %{message: "Dashboard card not found"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(DashboardApiWeb.Views.DashboardCardJSON)
        |> render("error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"dashboard_card_id" => dashboard_card_id}) do

    case Dashboards.delete_dashboard_card(dashboard_card_id, %{}) do
      {:ok, _card} ->
        conn
        |> put_status(:no_content)
        |> send_resp(:no_content, "")

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(:error, message: "Dashboard card not found")
    end
  end
end
