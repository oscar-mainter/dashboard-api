defmodule DashboardApi.Repo.Migrations.DashboardCards do
  use Ecto.Migration

  def change do
    create table (:dashboard_cards) do
      add :system_id, references(:systems, on_delete: :nothing), null: false
      add :dashboard_id, references(:dashboards, on_delete: :nothing), null: false
      add :x, :integer, null: false
      add :y, :integer, null: false
      add :w, :integer, null: false
      add :h, :integer, null: false
      timestamps(type: :utc_datetime)
    end

    create index(:dashboard_cards, [:dashboard_id])
  end
end
