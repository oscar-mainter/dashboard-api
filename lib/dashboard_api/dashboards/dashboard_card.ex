defmodule DashboardApi.Dashboards.DashboardCard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dashboard_cards" do
    field :x, :integer
    field :y, :integer
    field :w, :integer
    field :h, :integer
    belongs_to :system, DashboardApi.Dashboards.System
    belongs_to :dashboard, DashboardApi.Dashboards.Dashboard
    timestamps(type: :utc_datetime)
  end

  def changeset(dashboard_card, attrs) do
    dashboard_card
    |> cast(attrs, [:x, :y, :w, :h])
    |> validate_required([:x, :y, :w, :h])
    |> put_required_ids(attrs)
    |> validate_required([:system_id, :dashboard_id])
    |> foreign_key_constraint(:dashboard_id)
    |> foreign_key_constraint(:system_id)
    |> validate_number(:x, greater_than_or_equal_to: 0, message: "x must be greater than or equal to 0")
    |> validate_number(:y, greater_than_or_equal_to: 0, message: "y must be greater than or equal to 0")
    |> validate_number(:w, greater_than: 0, message: "w must be greater than 0")
    |> validate_number(:h, greater_than: 0, message: "h must be greater than 0")
  end

  defp put_required_ids(changeset, attrs) do
    system_id = attrs["system_id"] || attrs[:system_id]
    dashboard_id = attrs["dashboard_id"] || attrs[:dashboard_id]

    changeset
    |> put_change(:system_id, system_id)
    |> put_change(:dashboard_id, dashboard_id)
  end

  def update_changeset(dashboard_card, attrs) do
    dashboard_card
    |> cast(attrs, [:x, :y, :w, :h])
    |> validate_required([:x, :y, :w, :h])
    |> validate_number(:x, greater_than_or_equal_to: 0, message: "x must be greater than or equal to 0")
    |> validate_number(:y, greater_than_or_equal_to: 0, message: "y must be greater than or equal to 0")
    |> validate_number(:w, greater_than: 0, message: "w must be greater than 0")
    |> validate_number(:h, greater_than: 0, message: "h must be greater than 0")
  end
end
