defmodule DashboardApiWeb.DashboardJSON do
  alias DashboardApiWeb.DashboardCardJSON

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
      cards: get_cards(dashboard)
    }
  end

  def error(%{message: message}) do
    %{error: message}
  end

  def error(%{changeset: changeset}) do
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

  defp get_cards(dashboard) do
    case Map.get(dashboard, :dashboard_cards) do
      %Ecto.Association.NotLoaded{} -> []
      nil -> []
      cards -> for(card <- cards, do: DashboardCardJSON.show(card))
    end
  end
end
