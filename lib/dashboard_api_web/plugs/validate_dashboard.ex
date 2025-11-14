defmodule DashboardApiWeb.Plugs.ValidateDashboard do
  @moduledoc """
  Validates that dashboard_id exists and belongs to the validated user and system.
  Requires ValidateSystemUser to run first.
  Expects dashboard_id in conn.params or conn.body_params.
  """

  import Plug.Conn
  alias DashboardApi.Repo
  alias DashboardApi.Dashboards.Dashboard

  def init(opts), do: opts

  def call(conn, _opts) do
    params = conn.params || conn.body_params || %{}
    dashboard_id = params["dashboard_id"] || params[:dashboard_id]
    system_id = conn.assigns[:system_id]
    user_id = conn.assigns[:user_id]

    cond do
      is_nil(system_id) or is_nil(user_id) ->
        conn
        |> put_status(:internal_server_error)
        |> Phoenix.Controller.json(%{error: "system_id and user_id must be validated first"})
        |> halt()

      is_nil(dashboard_id) ->
        conn
        |> put_status(:bad_request)
        |> Phoenix.Controller.json(%{error: "dashboard_id is required"})
        |> halt()

      true ->
        validate_dashboard(conn, dashboard_id, system_id,user_id)
      end
  end

  defp validate_dashboard(conn, dashboard_id, system_id, user_id) do
    dashboard = Repo.get(Dashboard, dashboard_id)

    cond do
      is_nil(dashboard) ->
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "dashboard not found"})
        |> halt()

      dashboard.user_id != user_id ->
        conn
        |> put_status(:forbidden)
        |> Phoenix.Controller.json(%{error: "user does not have access to this dashboard"})
        |> halt()

      dashboard.system_id != system_id ->
        conn
        |> put_status(:forbidden)
        |> Phoenix.Controller.json(%{error: "dashboard does not belong to this system"})
        |> halt()

      true ->
        conn
        |> assign(:validated_dashboard, dashboard)
        |> assign(:dashboard_id, dashboard_id)
    end
  end
end
