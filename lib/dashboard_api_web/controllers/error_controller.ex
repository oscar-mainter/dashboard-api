defmodule DashboardApiWeb.ErrorController do
  use DashboardApiWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(DashboardApiWeb.Views.ErrorJSON)
    |> render("error.json", message: "Not found")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(DashboardApiWeb.Views.ErrorJSON)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, reason}) when is_atom(reason) or is_binary(reason) do
    conn
    |> put_status(:bad_request)
    |> put_view(DashboardApiWeb.Views.ErrorJSON)
    |> render("error.json", message: to_string(reason))
  end

  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
