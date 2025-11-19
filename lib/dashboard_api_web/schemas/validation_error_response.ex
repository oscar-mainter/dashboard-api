defmodule DashboardApiWeb.Schemas.ValidationErrorResponse do
  alias OpenApiSpex.Schema

  @doc """
  Used for 422 validation errors.
  """
  def schema do
    %Schema{
      title: "ValidationErrorResponse",
      type: :object,
      properties: %{
        errors: %Schema{
          type: :object,
          additionalProperties: %Schema{type: :array, items: %Schema{type: :string}},
          description: "Map of fields to validation errors"
        }
      },
      required: [:errors]
    }
  end

  def response do
    {"Validation Errors", "application/json", schema()}
  end
end
