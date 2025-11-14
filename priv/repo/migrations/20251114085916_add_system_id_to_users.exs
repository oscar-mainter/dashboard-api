defmodule DashboardApi.Repo.Migrations.AddSystemIdToUsers do
  use Ecto.Migration

  def change do
    alter table (:users) do
      add :system_id, references(:systems, on_delete: :nothing), null: false
    end

    create index(:users, [:system_id])
  end
end
