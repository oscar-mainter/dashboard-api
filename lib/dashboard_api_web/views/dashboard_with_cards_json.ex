defmodule DashboardApiWeb.Views.DashboardWithCardsJSON do
  alias DashboardApiWeb.Views.DashboardCardJSON

  def render("index.json", %{dashboards: dashboards}) do
    %{data: for(dashboard <- dashboards, do: render("show.json", %{dashboard: dashboard}))}
  end

  def render("show.json", %{dashboard: dashboard}) do
    %{
      id: dashboard.id,
      name: dashboard.name,
      inserted_at: dashboard.inserted_at,
      updated_at: dashboard.updated_at,
      cards: get_cards(dashboard)
    }
  end

  defp get_cards(dashboard) do
    case Map.get(dashboard, :dashboard_cards) do
      %Ecto.Association.NotLoaded{} -> []
      nil -> []
      cards -> for card <- cards, do: DashboardCardJSON.render("show.json", %{card: card})
    end
  end

end
