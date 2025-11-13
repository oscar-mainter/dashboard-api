defmodule DashboardApi.Repo do
  use Ecto.Repo,
    otp_app: :dashboard_api,
    adapter: Ecto.Adapters.Postgres
end
