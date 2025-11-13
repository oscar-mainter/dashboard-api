defmodule DashboardApi.Dashboards.Systems do
  use Ecto.Schema
  import Ecto.Changeset

  schema "systems" do
    field :name, :string
    has_many :dashboards, DashboardApi.Dashboards.Dashboards
    timestamps(type: :utc_datetime)
  end

  def changeset(system, attrs) do
    system
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
