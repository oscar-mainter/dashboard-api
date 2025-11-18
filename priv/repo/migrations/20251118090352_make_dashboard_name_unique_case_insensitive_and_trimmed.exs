defmodule DashboardApi.Repo.Migrations.MakeDashboardNameUniqueCaseInsensitiveAndTrimmed do
  use Ecto.Migration

  def change do

    drop unique_index(:dashboards, [:user_id, :name],
      name: :dashboards_user_id_name_index
    )
    create unique_index(
      :dashboards,
      [:user_id, "lower(trim(name))"],
      name: :dashboards_user_id_name_index
      )
  end
end
