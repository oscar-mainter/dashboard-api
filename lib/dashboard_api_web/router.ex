defmodule DashboardApiWeb.Router do
  use DashboardApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug DashboardApiWeb.Plugs.NormalizeAndValidateIds
  end

  pipeline :openapi do
    plug OpenApiSpex.Plug.PutApiSpec, module: DashboardApiWeb.ApiSpec
  end

  scope "/" do
    pipe_through :openapi

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
    get "/docs", OpenApiSpex.Plug.SwaggerUI, path: "/openapi"
  end


  pipeline :validate_dashboard do
    plug DashboardApiWeb.Plugs.ValidateSystemUser
    plug DashboardApiWeb.Plugs.ValidateDashboard
  end

  scope "/api/v1/systems/:system_id/users/:user_id/dashboards", DashboardApiWeb do
    pipe_through [:api, DashboardApiWeb.Plugs.ValidateSystemUser]

    post "/", DashboardController, :create
    get "/", DashboardController, :index
    get "/:dashboard_id", DashboardController, :show
    delete "/:dashboard_id", DashboardController, :delete

    scope "/:dashboard_id/cards" do
      pipe_through :validate_dashboard

      post "/", DashboardCardController, :create
      patch "/:dashboard_card_id", DashboardCardController, :update
      delete "/:dashboard_card_id", DashboardCardController, :delete
    end
  end

  match :*, "/*path", DashboardApiWeb.Plugs.CatchAll, :not_found
end
