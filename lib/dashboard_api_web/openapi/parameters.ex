defmodule DashboardApiWeb.OpenAPI.Parameters do
  alias OpenApiSpex.Schema

  def system_id do
    %OpenApiSpex.Parameter{
      name: :system_id,
      in: :path,
      description: "System ID",
      required: true,
      schema: %Schema{type: :integer}
    }
  end

  def user_id do
    %OpenApiSpex.Parameter{
      name: :user_id,
      in: :path,
      description: "User ID",
      required: true,
      schema: %Schema{type: :integer}
    }
  end

  def dashboard_id do
    %OpenApiSpex.Parameter{
      name: :dashboard_id,
      in: :path,
      description: "Dashboard ID",
      required: true,
      schema: %Schema{type: :integer}
    }
  end

  def dashboard_card_id do
    %OpenApiSpex.Parameter{
      name: :dashboard_card_id,
      in: :path,
      description: "Dashboard Card ID",
      required: true,
      schema: %Schema{type: :integer}
    }
  end
end
