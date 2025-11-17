defmodule DashboardApi.Dashboards.Dashboard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dashboards" do
    field :name, :string
    belongs_to :system, DashboardApi.Dashboards.System
    belongs_to :user, DashboardApi.Users.User
    has_many :dashboard_cards, DashboardApi.Dashboards.DashboardCard, foreign_key: :dashboard_id, on_delete: :delete_all
    timestamps(type: :utc_datetime)
  end

  def changeset(dashboard, attrs) do
    dashboard
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_required_ids(attrs)
    |> validate_required([:system_id, :user_id])
    |> validate_length(:name, min: 1, max: 100, message: "name must be between 1 and 100 characters")
    |> foreign_key_constraint(:system_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:name, name: :dashboards_user_id_name_index)
  end

  defp put_required_ids(changeset, attrs) do
    system_id = attrs["system_id"] || attrs[:system_id]
    user_id = attrs["user_id"] || attrs[:user_id]

    changeset
    |> put_change(:system_id, system_id)
    |> put_change(:user_id, user_id)
  end
end
