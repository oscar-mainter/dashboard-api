defmodule DashboardApi.Dashboards.DashboardCards do
  @moduledoc """
  The DashboardCards context - handles card creation, updates, and deletion.
  """

  alias DashboardApi.Repo
  alias DashboardApi.Dashboards.DashboardCard

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
