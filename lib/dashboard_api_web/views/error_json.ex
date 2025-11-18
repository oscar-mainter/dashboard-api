defmodule DashboardApiWeb.Views.ErrorJSON do
  def render("error.json", %{message: message}) when is_binary(message) do
    %{error: message}
  end

  def render("error.json", %{changeset: %Ecto.Changeset{} = changeset}) do
    %{
      error: "Validation failed",
      errors: translate_errors(changeset)
    }
  end

  def render("error.json", %{message: message}) do
    %{error: to_string(message)}
  end

  def render("error.json", %{reason: reason}) do
    %{error: to_string(reason)}
  end

  def render(template, _assigns) do
    %{error: "Unknown error", template: template}
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
