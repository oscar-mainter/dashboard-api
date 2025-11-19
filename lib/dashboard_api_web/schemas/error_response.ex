defmodule DashboardApiWeb.Schemas.ErrorResponse do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  def schema do
    %Schema{
      title: "Error",
      type: :object,
      properties: %{
        error: %Schema{type: :string},
        message: %Schema{type: :string}
      },
      required: [:error, :message]
    }
  end

  def response do
    {"Error Response", "application/json", schema()}
  end
end
