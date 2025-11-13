defmodule DashboardApi.Repo.Migrations.Dashboards do
  use Ecto.Migration

  def change do
    create table (:dashboards) do
      add :system_id, references(:systems, on_delete: :nothing), null: false
      add :name, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create index(:dashboards, [:system_id])
  end
end
