defmodule DashboardApiWeb.Schemas.DashboardCard do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%Schema{
    title: "DashboardCard",
    description: "A card on a dashboard grid",
    type: :object,
    properties: %{
      id: %Schema{type: :integer},
      x: %Schema{type: :integer, description: "Grid X position"},
      y: %Schema{type: :integer, description: "Grid Y position"},
      w: %Schema{type: :integer, description: "Width in grid units"},
      h: %Schema{type: :integer, description: "Height in grid units"},
      inserted_at: %Schema{type: :string, format: :"date-time"},
      updated_at: %Schema{type: :string, format: :"date-time"}
    },
    required: [:x, :y, :w, :h]
  })
end
