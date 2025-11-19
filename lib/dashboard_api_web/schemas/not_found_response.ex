defmodule DashboardApiWeb.Schemas.NotFoundResponse do
  alias OpenApiSpex.Schema

  def schema do
    %Schema{
      title: "NotFoundResponse",
      type: :object,
      properties: %{
        error: %Schema{type: :string},
        message: %Schema{type: :string}
      },
      required: [:error, :message]
    }
  end

  def response do
    {"Not Found", "application/json", schema()}
  end
end
