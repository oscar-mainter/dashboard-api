defmodule DashboardApi.Dashboards.Dashboards do
  @moduledoc """
  The Dashboards context - handles dashboard operations.
  """

  alias DashboardApi.Repo
  alias DashboardApi.Dashboards.Dashboard
  alias DashboardApi.Dashboards.DashboardCard
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

  def list_dashboards_with_cards(system_id, user_id) do
    Dashboard
    |> where([d], d.system_id == ^system_id and d.user_id == ^user_id)
    |> preload(:dashboard_cards)
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

  def create_dashboard_card(attrs) do
    %DashboardCard{}
    |> DashboardCard.changeset(attrs)
    |> Repo.insert()
  end

  def update_dashboard_card(id, attrs) do
    update_attrs =
      attrs
      |> Map.drop(["system_id","dashboard_id", "user_id"])
      |> Map.drop([:system_id, :dashboard_id, :user_id])

    case Repo.get(DashboardCard, id) do
      nil ->
        {:error, :not_found}
      card ->
        card
        |> DashboardCard.update_changeset(update_attrs)
        |> Repo.update()
    end
  end

  def delete_dashboard_card(id, _attrs) do
    case Repo.get(DashboardCard, id) do
      nil -> {:error, :not_found}
      card -> Repo.delete(card)
    end
  end
end
