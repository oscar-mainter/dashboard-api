defmodule DashboardApiWeb.SwaggerController do
  use DashboardApiWeb, :controller

  def index(conn, _params) do
    redirect(conn,
      external:
        "https://unpkg.com/swagger-ui-dist/index.html?url=http://localhost:4000/openapi"
    )
  end

end
