defmodule DashboardApi.Repo.Migrations.AddUniqueNamePerUserToDashboards do
  use Ecto.Migration

  def change do
    create unique_index(:dashboards, [:user_id, :name], name: :dashboards_user_id_name_index)
  end
end
