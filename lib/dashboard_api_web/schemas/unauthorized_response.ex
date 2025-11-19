defmodule DashboardApiWeb.Schemas.UnauthorizedResponse do
  alias OpenApiSpex.Schema

  def schema do
    %Schema{
      title: "UnauthorizedResponse",
      type: :object,
      properties: %{
        error: %Schema{type: :string},
        message: %Schema{type: :string}
      },
      required: [:error, :message]
    }
  end

  def response do
    {"Unauthorized", "application/json", schema()}
  end
end
