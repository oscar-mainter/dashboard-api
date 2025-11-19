defmodule DashboardApiWeb.Schemas.Dashboard do
  require OpenApiSpex
  alias OpenApiSpex.Schema
  alias DashboardApiWeb.Schemas.DashboardCard

  OpenApiSpex.schema(%Schema{
    title: "Dashboard",
    description: "A user dashboard, optionally containing cards",
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
        items: DashboardCard,
        description: "Cards belonging to this dashboard"
      }
    },
    required: [:name]
  })
end
