import Config

# ──────────────────────────────────────────────────────────────
# DATABASE – Works perfectly with Docker PostgreSQL on localhost
# ──────────────────────────────────────────────────────────────
config :dashboard_api, DashboardApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5433,
  database: "dashboard_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# Optional: If you ever expose Docker on 5432 instead of 5433, change port to 5432

# ──────────────────────────────────────────────────────────────
# WEB ENDPOINT – No server needed in tests
# ──────────────────────────────────────────────────────────────
config :dashboard_api, DashboardApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "test-secret-key-that-is-long-enough-for-phoenix",
  server: false

# ──────────────────────────────────────────────────────────────
# EMAIL & LOGGING
# ──────────────────────────────────────────────────────────────
config :dashboard_api, DashboardApi.Mailer,
  adapter: Swoosh.Adapters.Test

config :swoosh, :api_client, false

config :logger, level: :warning

# Faster test compilation
config :phoenix, :plug_init_mode, :runtime
config :phoenix, :json_library, Jason
