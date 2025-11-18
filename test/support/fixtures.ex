# test/support/fixtures.ex
defmodule DashboardApi.Fixtures do
  alias DashboardApi.Repo
  alias DashboardApi.Dashboards.{System, Dashboard, DashboardCard}
  alias DashboardApi.Users.User

  def fixture(kind, attrs \\ [])

  def fixture(:system, attrs) do
    attrs = Enum.into(attrs, %{name: "Test System"})
    %System{} |> System.changeset(attrs) |> Repo.insert!()
  end

  def fixture(:user, attrs) do
    attrs = Enum.into(attrs, %{})

    system = attrs[:system] || attrs["system"] || fixture(:system)

    %User{}
    |> User.changeset(%{name: "Test User", system_id: system.id})
    |> Repo.insert!()
  end

  def fixture(:dashboard, attrs) do
    attrs = Enum.into(attrs, %{})

    system = attrs[:system] || attrs["system"] || fixture(:system)
    user = attrs[:user] || attrs["user"] || fixture(:user, system: system)
    name = attrs[:name] || attrs["name"] || "Test Dashboard"

    %Dashboard{}
    |> Dashboard.changeset(%{name: name, system_id: system.id, user_id: user.id})
    |> Repo.insert!()
  end

  def fixture(:dashboard_card, attrs) do
    attrs = Enum.into(attrs, %{})
    dashboard = attrs[:dashboard] || attrs["dashboard"] || fixture(:dashboard)

    %DashboardCard{}
    |> DashboardCard.changeset(%{
      x: 0, y: 0, w: 4, h: 4,
      dashboard_id: dashboard.id,
      system_id: dashboard.system_id
    })
    |> Repo.insert!()
  end

  def fixture(kind, _attrs) do
    raise "No fixture defined for #{inspect(kind)}"
  end
end
