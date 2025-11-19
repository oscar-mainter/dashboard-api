# DashboardApi

## Development Setup

### Requirements

- Elixir / Erlang (as specified in `.tool-versions`)
- PostgreSQL **16** running on **port 5433**
- Node.js (optional, if you build assets)

### Install dependencies

```bash
mix deps.get
```

### Database Setup

This project includes a custom mix alias for resetting the database and seeding it with dummy data.

Add this inside `mix.exs` under `defp aliases do` if not already present:

```elixir
defp aliases do
  [
    "db.reset": ["ecto.drop", "ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"]
  ]
end
```

Use it to fully reset + seed the database:

```bash
mix db.reset
```

---

## API & Documentation

### OpenAPI JSON

```
GET /openapi
```

### Swagger UI

```
GET /docs
```

### API Endpoints

```
POST   /api/v1/systems/:system_id/users/:user_id/dashboards
GET    /api/v1/systems/:system_id/users/:user_id/dashboards
GET    /api/v1/systems/:system_id/users/:user_id/dashboards/:dashboard_id
DELETE /api/v1/systems/:system_id/users/:user_id/dashboards/:dashboard_id

POST   /api/v1/systems/:system_id/users/:user_id/dashboards/:dashboard_id/cards
PATCH  /api/v1/systems/:system_id/users/:user_id/dashboards/:dashboard_id/cards/:dashboard_card_id
DELETE /api/v1/systems/:system_id/users/:user_id/dashboards/:dashboard_id/cards/:dashboard_card_id
```
