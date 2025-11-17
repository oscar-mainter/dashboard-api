defmodule DashboardApiWeb.Views.DashboardJSON do

  def render("index.json", %{dashboards: dashboards}) do
    %{data: for(dashboard <- dashboards, do: render("show.json", %{dashboard: dashboard}))}
  end

  def render("show.json", %{dashboard: dashboard}) do
    %{
      id: dashboard.id,
      name: dashboard.name,
      inserted_at: dashboard.inserted_at,
      updated_at: dashboard.updated_at
    }
  end


  def render("error.json", %{message: message}) do
    %{error: message}
  end

  def render("error.json", %{changeset: changeset}) do
    %{
      error: "Validation failed",
      errors: translate_errors(changeset)
    }
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
