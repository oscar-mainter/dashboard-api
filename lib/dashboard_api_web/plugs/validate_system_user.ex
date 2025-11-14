defmodule DashboardApiWeb.Plugs.ValidateSystemUser do
  @moduledoc """
  Validates that user_id and system_id exist and that the user belongs to the system.
  Expects user_id and system_id in conn.params or conn.body_params.
  """

  import Plug.Conn
  alias DashboardApi.Repo
  alias DashboardApi.Users.User
  alias DashboardApi.Dashboards.System

  def init(opts), do: opts

  def call(conn, _opts) do
    params = conn.params || conn.body_params || %{}
    system_id = params["system_id"] || params[:system_id]
    user_id = params["user_id"] || params[:user_id]

    cond do
      is_nil(system_id) ->
        conn
        |> put_status(:bad_request)
        |> Phoenix.Controller.json(%{error: "system_id is required"})
        |> halt()

      is_nil(user_id) ->
        conn
        |> put_status(:bad_request)
        |> Phoenix.Controller.json(%{error: "user_id is required"})
        |> halt()

      true ->
        validate_system_user(conn, system_id, user_id)
    end
  end

  defp validate_system_user(conn, system_id, user_id) do
    system = Repo.get(System, system_id)
    user = Repo.get(User, user_id)

    cond do
      is_nil(system) ->
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "system not found"})
        |> halt()

      is_nil(user) ->
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "user not found"})
        |> halt()

      user.system_id != system_id ->
        conn
        |> put_status(:forbidden)
        |> Phoenix.Controller.json(%{error: "user does not belong to system"})
        |> halt()

      true ->
        conn
        |> assign(:validated_system, system)
        |> assign(:validated_user, user)
        |> assign(:user_id, user_id)
        |> assign(:system_id, system_id)
    end
  end
end
