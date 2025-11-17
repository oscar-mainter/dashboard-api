alias DashboardApi.Repo
alias DashboardApi.Dashboards.{Dashboard, DashboardCard, System}
alias DashboardApi.Users.User

# Delete everything first
Repo.transaction(fn ->
  Repo.delete_all(DashboardCard)
  Repo.delete_all(Dashboard)
  Repo.delete_all(User)
  Repo.delete_all(System)

  # Create systems
  systems =
    for i <- 1..3 do
      %System{name: "System #{i}"}
      |> Repo.insert!()
    end

  # Create users
  users =
    for i <- 1..3 do
      %User{name: "User #{i}", system_id: Enum.at(systems, i - 1).id}
      |> Repo.insert!()
    end

  # Create dashboards for each user
  Enum.each(users, fn user ->
    for j <- 1..2 do
      dashboard =
        %Dashboard{name: "Dashboard #{j} for #{user.name}", system_id: user.system_id, user_id: user.id}
        |> Repo.insert!()

      # Create 10 dashboard cards per dashboard with unique coordinates
      for k <- 1..10 do
        %DashboardCard{
          dashboard_id: dashboard.id,
          system_id: user.system_id,
          x: rem(k-1, 5),
          y: div(k-1, 5),
          w: 2,
          h: 2
        }
        |> Repo.insert!()
      end
    end
  end)
end)

IO.puts("✅ Seeded 3 systems, 3 users, 2 dashboards per user, 10 cards per dashboard.")
