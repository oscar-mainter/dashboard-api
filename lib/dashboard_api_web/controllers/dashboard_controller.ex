defmodule DashboardApiWeb.DashboardController do
  use DashboardApiWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias DashboardApi.Dashboards.Dashboards
  alias DashboardApiWeb.Schemas.{
    Dashboard,
    DashboardWithCards,
    DashboardIndex,
    ErrorResponse,
    ValidationErrorResponse,
    NotFoundResponse
  }
  alias DashboardApiWeb.OpenAPI.Parameters

  action_fallback DashboardApiWeb.ErrorController
  plug DashboardApiWeb.Plugs.ValidateBody, fields: [:name], only: [:create]

  tags ["Dashboards"]

  @doc """
  POST /systems/:system_id/users/:user_id/dashboards
  """
  operation :create,
    summary: "Create dashboard",
    description: "Creates a dashboard under a specific system and user.",
    parameters: [
      Parameters.system_id(),
      Parameters.user_id()
    ],
    request_body:
      {"Dashboard Create Body", "application/json",
      %OpenApiSpex.Schema{
        type: :object,
        required: [:name],
        properties: %{
          name: %OpenApiSpex.Schema{type: :string}
        }
      }},
    responses: %{
      201 => {"Dashboard Created", "application/json", DashboardWithCards},
      400 => ErrorResponse.response(),
      422 => ValidationErrorResponse.response()
    }

  def create(conn, params) do
    attrs = Map.take(params, ["name", "system_id", "user_id"])

    with {:ok, dashboard} <- Dashboards.create_dashboard(attrs) do
      conn
      |> put_status(:created)
      |> put_view(DashboardApiWeb.Views.DashboardWithCardsJSON)
      |> render(:show, %{dashboard: dashboard})
    end
  end

  @doc """
  GET /systems/:system_id/users/:user_id/dashboards?cards=true
  """
  operation :index,
    summary: "List dashboards",
    description: "Lists dashboards for a system/user. Pass `?cards=true` to include full dashboard cards.",
    parameters: [
      Parameters.system_id(),
      Parameters.user_id(),
      %OpenApiSpex.Parameter{
        name: :cards,
        in: :query,
        description: "Whether to include all dashboard cards",
        required: false,
        schema: %OpenApiSpex.Schema{type: :boolean}
      }
    ],
    responses: %{
      200 => {"Dashboards List", "application/json", DashboardIndex},
      404 => NotFoundResponse.response()
    }

  def index(conn, %{"system_id" => system_id, "user_id" => user_id} = params) do
    view =
      if params["cards"] == "true",
        do: DashboardApiWeb.Views.DashboardWithCardsJSON,
        else: DashboardApiWeb.Views.DashboardJSON

      dashboards =
        if view == DashboardApiWeb.Views.DashboardWithCardsJSON,
          do: Dashboards.list_dashboards_with_cards(system_id, user_id),
          else: Dashboards.list_dashboards(system_id, user_id)

      conn
      |> put_view(view)
      |> render("index.json", %{dashboards: dashboards})
  end


  @doc """
  GET /systems/:system_id/users/:user_id/dashboards/:dashboard_id
  """
  operation :show,
    summary: "Get single dashboard",
    parameters: [
      Parameters.system_id(),
      Parameters.user_id(),
      Parameters.dashboard_id()
    ],
    responses: %{
      200 => {"Dashboard", "application/json", Dashboard},
      404 => NotFoundResponse.response()
    }

  def show(conn, %{"dashboard_id" => dashboard_id}) do
    with {:ok, dashboard} <- Dashboards.get_dashboard(dashboard_id) do
      conn
      |> put_view(DashboardApiWeb.Views.DashboardJSON)
      |> render("show.json", %{dashboard: dashboard})
    end
  end

  @doc """
  DELETE /systems/:system_id/users/:user_id/dashboards/:dashboard_id
  """
  operation :delete,
    summary: "Delete dashboard",
    parameters: [
      Parameters.system_id(),
      Parameters.user_id(),
      Parameters.dashboard_id()
    ],
    responses: %{
      204 => {"No Content", nil, nil},
      404 => NotFoundResponse.response()
    }

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"dashboard_id" => dashboard_id}) do
    with {:ok, _dashboard} <- Dashboards.delete_dashboard(dashboard_id) do
      conn
      |> send_resp(:no_content, "")
    end
  end
end
