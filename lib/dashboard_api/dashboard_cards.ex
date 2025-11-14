defmodule DashboardApi.Dashboards.DashboardCards do
  @moduledoc """
  The DashboardCards context - handles card creation, updates, and deletion.
  """

  import Ecto.Changeset
  alias DashboardApi.Repo
  alias DashboardApi.Dashboards.DashboardCard

  def create_dashboard_card(dashboard, attrs \\ %{}) do
    %DashboardCard{}
    |> DashboardCard.changeset(attrs)
    |> put_assoc(:dashboard, dashboard)
    |> Repo.insert()
  end

  def update_dashboard_card(dashboard_card, attrs \\ %{}) do
    case Repo.get(DashboardCard,dashboard_card.id) do
      nil -> {:error, :not_found}
      card ->
        card
        |> DashboardCard.changeset(attrs)
        |> Repo.update()
    end
  end

  def delete_dashboard_card(id) do
    case Repo.get(DashboardCard, id) do
      nil -> {:error, :not_found}
      card -> Repo.delete(card)
    end
  end
end
