defmodule DashboardApiWeb.Views.DashboardCardJSON do
  def render("index.json", %{cards: cards}) do
    %{data: for(card <- cards, do: render("show.json", %{card: card}))}
  end

  def render("show.json", %{card: card}) do
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
