defmodule DashboardApi.Dashboards.Dashboards do
  @moduledoc """
  The Dashboards context - handles dashboard operations.
  """

  alias DashboardApi.Repo
  alias DashboardApi.Dashboards.Dashboard
  import Ecto.Query

  def create_dashboard(attrs) do
    %Dashboard{}
    |> Dashboard.changeset(attrs)
    |> Repo.insert()
  end

  def get_dashboard(dashboard_id) do
    case Repo.get(Dashboard, dashboard_id) |> Repo.preload(:dashboard_cards) do
      nil ->
        {:error, :not_found}
      dashboard ->
        {:ok, dashboard}
    end
  end

  def list_dashboards(system_id, user_id) do
    Dashboard
    |> where([d], d.system_id == ^system_id and d.user_id == ^user_id)
    |> Repo.all()
  end

  def delete_dashboard(dashboard_id) do
    case Repo.get(Dashboard, dashboard_id) do
      nil ->
        {:error, :not_found}
      dashboard ->
        Repo.delete(dashboard)
    end
  end
end
