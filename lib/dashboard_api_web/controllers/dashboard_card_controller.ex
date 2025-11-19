defmodule DashboardApiWeb.DashboardCardController do
  use DashboardApiWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias DashboardApi.Dashboards.Dashboards
  alias DashboardApiWeb.Schemas.{
    DashboardCard,
    ErrorResponse,
    ValidationErrorResponse,
    NotFoundResponse,
    UnauthorizedResponse
  }
  alias DashboardApiWeb.OpenAPI.Parameters

  action_fallback DashboardApiWeb.ErrorController
  plug DashboardApiWeb.Plugs.ValidateBody, fields: [:x, :y, :w, :h], only: [:create]

  tags ["Dashboard Cards"]

  @doc """
  POST /systems/:system_id/users/:user_id/dashboards/:dashboard_id/cards
  """
  operation :create,
  summary: "Create a dashboard card",
    parameters: [
      Parameters.system_id(),
      Parameters.user_id(),
      Parameters.dashboard_id()
    ],
    request_body:
      {"Card Create Body", "application/json",
      %OpenApiSpex.Schema{
        type: :object,
        required: [:x, :y, :w, :h],
        properties: %{
          x: %OpenApiSpex.Schema{type: :integer},
          y: %OpenApiSpex.Schema{type: :integer},
          w: %OpenApiSpex.Schema{type: :integer},
          h: %OpenApiSpex.Schema{type: :integer}
        }
      }},
    responses: %{
      201 => {"Card Created", "application/json", DashboardCard},
      400 => ErrorResponse.response(),
      403 => UnauthorizedResponse.response(),
      422 => ValidationErrorResponse.response()
    }

  def create(conn, params) do
    attrs = Map.take(params, ["x", "y", "w", "h", "system_id", "dashboard_id"])

    with {:ok, card} <- Dashboards.create_dashboard_card(attrs) do
      conn
      |> put_status(:created)
      |> put_view(DashboardApiWeb.Views.DashboardCardJSON)
      |> render("show.json", %{card: card})
    end
  end

  @doc """
  PATCH /systems/:system_id/users/:user_id/dashboards/:dashboard_id/cards/:dashboard_card_id
  """
  operation :update,
    summary: "Update card position/size",
    parameters: [
      Parameters.system_id(),
      Parameters.user_id(),
      Parameters.dashboard_id(),
      Parameters.dashboard_card_id()
    ],
    request_body:
      {"Card Update Body", "application/json",
      %OpenApiSpex.Schema{
        type: :object,
        description: "Only send fields to update",
        properties: %{
          x: %OpenApiSpex.Schema{type: :integer},
          y: %OpenApiSpex.Schema{type: :integer},
          w: %OpenApiSpex.Schema{type: :integer},
          h: %OpenApiSpex.Schema{type: :integer}
        }
      }},
    responses: %{
      200 => {"Updated Card", "application/json", DashboardCard},
      403 => UnauthorizedResponse.response(),
      404 => NotFoundResponse.response(),
      422 => ValidationErrorResponse.response()
    }

  def update(conn, %{"dashboard_card_id" => dashboard_card_id} = params) do
    attrs = Map.take(params,["x", "y", "w", "h"])

    with {:ok, card} <- Dashboards.update_dashboard_card(dashboard_card_id, attrs) do
      conn
      |> put_view(DashboardApiWeb.Views.DashboardCardJSON)
      |> render("show.json", %{card: card})
    end
  end

  @doc """
  DELETE /systems/:system_id/users/:user_id/dashboards/:dashboard_id/cards/:dashboard_card_id
  """
  operation :delete,
    summary: "Delete a dashboard card",
    parameters: [
      Parameters.system_id(),
      Parameters.user_id(),
      Parameters.dashboard_id(),
      Parameters.dashboard_card_id()
    ],
    responses: %{
      204 => {"No Content", nil, nil},
      403 => UnauthorizedResponse.response(),
      404 => NotFoundResponse.response()
    }

  def delete(conn, %{"dashboard_card_id" => dashboard_card_id}) do
    with {:ok, _card} <- Dashboards.delete_dashboard_card(dashboard_card_id, %{}) do
      conn
      |> send_resp(:no_content, "")
    end

  end
end
