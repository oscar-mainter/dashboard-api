defmodule DashboardApi.Repo.Migrations.AddUserIdToDashboards do
  use Ecto.Migration

  def change do
    alter table (:dashboards) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:dashboards, [:user_id])
  end
end
