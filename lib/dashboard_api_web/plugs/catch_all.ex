defmodule DashboardApiWeb.Plugs.CatchAll do
  alias DashboardApiWeb.PageController

  def init(opts), do: opts

  def call(conn, _opts) do
    PageController.not_found(conn, %{})
  end
end
