defmodule DashboardApi.Dashboards.Dashboards do
  @moduledoc """
  The Dashboards context - handles dashboard operations.
  """

  use Ecto.Schema
  alias DashboardApi.Repo
  alias DashboardApi.Dashboards.Dashboard

  def create_dashboard(attrs) do
    %Dashboard{}
    |> Dashboard.changeset(attrs)
    |> Repo.insert()
  end

  def get_dashboard(id) do
    Repo.get(Dashboard, id)
  end

  def delete_dashboard(id) do
    case Repo.get(Dashboard, id) do
      nil -> {:error, :not_found}
      dashboard -> Repo.delete(dashboard)
    end
  end
end
