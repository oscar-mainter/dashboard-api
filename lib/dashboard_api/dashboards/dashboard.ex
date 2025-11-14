defmodule DashboardApi.Dashboards.Dashboard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dashboards" do
    field :name, :string
    belongs_to :system, DashboardApi.Dashboards.System
    belongs_to :user, DashboardApi.Users.User
    has_many :dashboard_cards, DashboardApi.Dashboards.DashboardCard, foreign_key: :dashboard_id
    timestamps(type: :utc_datetime)
  end

  def changeset(dashboard, attrs) do
    dashboard
    |> cast(attrs, [:name])
    |> validate_required([:name, :system_id, :user_id])
    |> validate_length(:name, min: 1, max: 100, message: "name must be between 1 and 100 characters")
    |> foreign_key_constraint(:system_id)
    |> foreign_key_constraint(:user_id)
  end
end
