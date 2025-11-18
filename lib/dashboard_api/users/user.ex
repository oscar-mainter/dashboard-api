defmodule DashboardApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string

    belongs_to :system, DashboardApi.Dashboards.System

    has_many :dashboards, DashboardApi.Dashboards.Dashboard,
      foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :system_id])
    |> validate_required([:name, :system_id])
    |> validate_length(:name, min: 1, max: 100,
      message: "name must be between 1 and 100 characters")
    |> unique_constraint(:name, name: :users_name_system_id_index)
    |> foreign_key_constraint(:system_id)
  end
end
