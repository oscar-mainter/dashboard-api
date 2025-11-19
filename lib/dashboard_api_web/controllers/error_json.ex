defmodule DashboardApiWeb.ErrorJSON do
  # Standard Phoenix 1.7 default error view

  def render("404.json", _assigns) do
    %{errors: %{detail: "Not Found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal Server Error"}}
  end

  def render(_, _assigns) do
    %{errors: %{detail: "Unknown error"}}
  end
end
