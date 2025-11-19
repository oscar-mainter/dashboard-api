defmodule DashboardApiWeb.Schemas.DashboardWithCards do
  require OpenApiSpex
  alias OpenApiSpex.Schema
  alias DashboardApiWeb.Schemas.{DashboardCard}

  OpenApiSpex.schema(%Schema{
    title: "DashboardWithCards",
    description: "Dashboard including all cards",
    type: :object,
    properties: %{
      id: %Schema{type: :integer},
      name: %Schema{type: :string},
      system_id: %Schema{type: :integer},
      user_id: %Schema{type: :integer},
      inserted_at: %Schema{type: :string, format: :"date-time"},
      updated_at: %Schema{type: :string, format: :"date-time"},
      cards: %Schema{
        type: :array,
        items: DashboardCard.schema(),
        description: "Cards belonging to this dashboard"
      }
    },
    required: [:name]
  })
end
