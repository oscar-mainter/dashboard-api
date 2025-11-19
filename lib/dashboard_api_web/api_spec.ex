defmodule DashboardApiWeb.ApiSpec do
  @moduledoc false
  alias OpenApiSpex.{OpenApi, Info, Paths}

  def spec do
    %OpenApi{
      info: %Info{
        title: "Dashboard API",
        version: "1.0.0"
      },
      paths: Paths.from_router(DashboardApiWeb.Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
