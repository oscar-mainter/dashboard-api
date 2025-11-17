defmodule DashboardApiWeb.Router do
  use DashboardApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug DashboardApiWeb.Plugs.ConvertToNumericParams
  end

  pipeline :validate_dashboard do
    plug DashboardApiWeb.Plugs.ValidateSystemUser
    plug DashboardApiWeb.Plugs.ValidateDashboard
  end

  get "/", DashboardApiWeb.PageController, :index

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
end
