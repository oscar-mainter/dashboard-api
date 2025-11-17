defmodule DashboardApiWeb.Views.DashboardCardJSON do
  def render("index.json", %{cards: cards}) do
    %{data: for(card <- cards, do: render("show.json", %{card: card}))}
  end

  def render("show.json", %{card: card}) do
    %{
      id: card.id,
      x: card.x,
      y: card.y,
      w: card.w,
      h: card.h,
      inserted_at: card.inserted_at,
      updated_at: card.updated_at
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
