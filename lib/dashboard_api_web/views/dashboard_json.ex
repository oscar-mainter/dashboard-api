defmodule DashboardApiWeb.DashboardJSON do
  def index(%{dashboards: dashboards}) do
    %{data: for(dashboard <- dashboards, do: show(dashboard))}
  end

  def show(%{dashboard: dashboard}) do
    %{data: show(dashboard)}
  end

  def show(dashboard) do
    %{
      id: dashboard.id,
      name: dashboard.name,
      system_id: dashboard.system_id,
      user_id: dashboard.user_id,
      inserted_at: dashboard.inserted_at,
      updated_at: dashboard.updated_at,
    }
  end

  def error(%{changeset: changeset}) do
    %{
      error: "Validation failed",
      errors: translate_errors(changeset)
    }
  end

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
