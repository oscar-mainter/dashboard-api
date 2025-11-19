defmodule DashboardApiWeb.Schemas.DashboardIndex do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  alias DashboardApiWeb.Schemas.Dashboard

  OpenApiSpex.schema(%Schema{
    title: "DashboardIndex",
    description: "List of dashboards",
    type: :object,
    properties: %{
      data: %Schema{
        type: :array,
        items: Dashboard.schema()
      }
    },
    required: [:data]
  })
end
