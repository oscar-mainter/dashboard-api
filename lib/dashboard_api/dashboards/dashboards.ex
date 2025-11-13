defmodule DashboardApi.Dashboards.Dashboards do
  use Ecto.Schema
  import Ecto.Changeset

  alias DashboardApi.Repo
  alias DashboardApi.Dashboards.Dashboards

  schema "dashboards" do
    field :name, :string
    belongs_to :system, DashboardApi.Dashboards.Systems
    has_many :dashboard_cards, DashboardApi.Dashboards.DashboardCards, foreign_key: :dashboard_id
    timestamps(type: :utc_datetime)
  end

  def create_dashboard(attrs) do
    %Dashboards{}
    |> Dashboards.changeset(attrs)
    |> Repo.insert()
  end

  def get_dashboard(id) do
    Repo.get(Dashboards, id)
  end

  def delete_dashboard(id) do
    case Repo.get(Dashboards, id) do
      nil -> {:error, :not_found}
      dashboard -> Repo.delete(dashboard)
    end
  end

  def changeset(dashboard, attrs) do
    dashboard
    |> cast(attrs, [:name])
    |> validate_required([:name, :system_id])
    |> validate_length(:name, min: 1, max: 100, message: "name must be between 1 and 100 characters")
    |> foreign_key_constraint(:system_id)
  end
end
