defmodule DashboardApiWeb.Views.DashboardJSON do

  def render("index.json", %{dashboards: dashboards}) do
    %{data: for(dashboard <- dashboards, do: render("show.json", %{dashboard: dashboard}))}
  end

  def render("show.json", %{dashboard: dashboard}) do
    %{data: %{
      id: dashboard.id,
      name: dashboard.name,
      inserted_at: dashboard.inserted_at,
      updated_at: dashboard.updated_at
    }}
  end
end
