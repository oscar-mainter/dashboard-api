defmodule DashboardApiWeb.DashboardCardController do
  use DashboardApiWeb, :controller

  alias DashboardApi.Dashboards.DashboardCards

  def create(conn, params) do
    attrs = %{
      "x" => params["x"],
      "y" => params["y"],
      "w" => params["w"],
      "h" => params["h"],
      "system_id" => params["system_id"],
      "dashboard_id" => params["dashboard_id"]
    }

    case DashboardCards.create_dashboard_card(attrs) do
      {:ok, card} ->
        conn
        |> put_status(:created)
        |> render(:show, card: card)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id} = params) do
    card_id = String.to_integer(id)

    update_attrs = %{
      "x" => params["x"],
      "y" => params["y"],
      "w" => params["w"],
      "h" => params["h"]
    }

    case DashboardCards.update_dashboard_card(card_id, update_attrs) do
      {:ok, card} ->
        conn
        |> render(:show, card: card)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(:error, message: "Dashboard card not found")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    card_id = String.to_integer(id)

    case DashboardCards.delete_dashboard_card(card_id, %{}) do
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
