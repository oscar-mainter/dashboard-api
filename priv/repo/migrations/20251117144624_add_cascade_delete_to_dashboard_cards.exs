defmodule DashboardApi.Repo.Migrations.AddCascadeDeleteToDashboardCards do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE dashboard_cards DROP CONSTRAINT dashboard_cards_dashboard_id_fkey"

    alter table(:dashboard_cards) do
      modify :dashboard_id, references(:dashboards, on_delete: :delete_all), null: false
    end
  end
end
