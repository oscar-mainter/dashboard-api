defmodule DashboardApi.Dashboards.Systems do
  use Ecto.Schema
  import Ecto.Changeset

  schema "systems" do
    field :name, :string
    has_many :dashboards, DashboardApi.Dashboards.Dashboard, foreign_key: :system_id
    timestamps(type: :utc_datetime)
  end

  def changeset(system, attrs) do
    system
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 100, message: "name must be between 1 and 100 characters")
  end
end
