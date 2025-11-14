defmodule DashboardApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    belongs_to :system, DashboardApi.Dashboards.System
    has_many :dashboards, DashboardApi.Dashboards.Dashboard, foreign_key: :user_id
    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 100, message: "name must be between 1 and 100 characters")
    |> foreign_key_constraint(:system_id)
  end
end
