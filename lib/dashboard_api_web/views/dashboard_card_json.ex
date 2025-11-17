defmodule DashboardApiWeb.DashboardCardJSON do
  def show(%{card: card}) do
    %{data: show(card)}
  end

  def show(card) do
    %{
      id: card.id,
      x: card.x,
      y: card.y,
      w: card.w,
      h: card.h,
      system_id: card.system_id,
      dashboard_id: card.dashboard_id,
      inserted_at: card.inserted_at,
      updated_at: card.updated_at,
    }
  end

  def error(%{message: message}) do
    %{error: message}
  end

  def error(%{changeset: changeset}) do
    %{error: "Validation failed", errors: translate_errors(changeset)}
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
