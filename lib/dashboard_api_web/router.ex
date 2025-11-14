defmodule DashboardApiWeb.Router do
  use DashboardApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DashboardApiWeb do
    pipe_through :api

    scope "/dashboards/:system_id/:user_id" do
      pipe_through DashboardApiWeb.Plugs.ValidateSystemUser

      post "/", DashboardController, :create
      get "/", DashboardController, :index
      get "/:dashboard_id", DashboardController, :show
      delete "/:dashboard_id", DashboardController, :delete
    end

    scope "/dashboards/:system_id/:user_id/:dashboard_id/cards" do
      pipe_through [DashboardApiWeb.Plugs.ValidateSystemUser, DashboardApiWeb.Plugs.ValidateDashboard]

      post "/", DashboardCardController, :create
      patch "/:id", DashboardCardController, :update
      delete "/:id", DashboardCardController, :delete
    end
  end
end
