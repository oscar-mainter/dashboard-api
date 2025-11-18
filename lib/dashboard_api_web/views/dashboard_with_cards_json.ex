defmodule DashboardApiWeb.Views.DashboardWithCardsJSON do
  def render("index.json", %{dashboards: dashboards}) do
    %{data: for(dashboard <- dashboards, do: data(dashboard))}
  end

  def render("show.json", %{dashboard: dashboard}) do
    %{data: data(dashboard)}
  end

  defp data(dashboard) do
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
      cards -> for card <- cards, do: card_data(card)
    end
  end

  defp card_data(card) do
    %{
      id: card.id,
      x: card.x,
      y: card.y,
      w: card.w,
      h: card.h,
      inserted_at: card.inserted_at,
      updated_at: card.updated_at
    }
  end
end
