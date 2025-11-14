defmodule DashboardApi.Dashboards.DashboardCards do
  @moduledoc """
  The DashboardCards context - handles card creation, updates, and deletion.
  """

  alias DashboardApi.Repo
  alias DashboardApi.Dashboards.DashboardCard
  alias DashboardApi.Dashboards.Dashboard

  def create_dashboard_card(attrs) do
    system_id = attrs["system_id"] || attrs[:system_id]
    user_id = attrs["user_id"] || attrs[:user_id]
    dashboard_id = attrs["dashboard_id"] || attrs[:dashboard_id]

    dashboard =
      case Repo.get(Dashboard, dashboard_id) do
        nil -> nil
        d -> d
      end

      case dashboard do
        nil ->
          {:error, %Ecto.Changeset{errors: [dashboard_id: {"not found", []}]}}
        d when d.user_id != user_id ->
          {:error, %Ecto.Changeset{errors: [user_id: {"not authorized", []}]}}
        d when d.system_id != system_id ->
            {:error, %Ecto.Changeset{errors: [system_id: {"not authorized", []}]}}
        _ ->
          %DashboardCard{}
          |> DashboardCard.changeset(attrs)
          |> Repo.insert()
      end
  end

  def update_dashboard_card(id, attrs) do
    system_id = attrs["system_id"] || attrs[:system_id]
    user_id = attrs["user_id"] || attrs[:user_id]

    update_attrs =
      attrs
      |> Map.drop(["system_id","dashboard_id", "user_id"])
      |> Map.drop([:system_id, :dashboard_id, :user_id])

    case Repo.get(DashboardCard, id) |> Repo.preload(:dashboard) do
      nil -> {:error, :not_found}
      card ->
        dashboard = card.dashboard

        cond do
          dashboard.user_id != user_id ->
            {:error, %Ecto.Changeset{errors: [user_id: {"not authorized", []}]}}
          dashboard.system_id != system_id ->
            {:error, %Ecto.Changeset{errors: [system_id: {"not authorized", []}]}}
          true ->
            card
            |> DashboardCard.update_changeset(update_attrs)
            |> Repo.update()
        end

    end
  end

  def delete_dashboard_card(id, attrs) do
    system_id = attrs["system_id"] || attrs[:system_id]
    user_id = attrs["user_id"] || attrs[:user_id]

    case Repo.get(DashboardCard, id) |> Repo.preload(:dashboard) do
      nil -> {:error, :not_found}
      card ->
        dashboard = card.dashboard

        cond do
          dashboard.user_id != user_id ->
            {:error, %Ecto.Changeset{errors: [user_id: {"not authorized", []}]}}
          dashboard.system_id != system_id ->
            {:error, %Ecto.Changeset{errors: [system_id: {"not authorized", []}]}}
          true ->
            Repo.delete(card)
        end
    end
  end
end
