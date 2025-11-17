defmodule DashboardApiWeb.Plugs.ValidateBody do
  import Plug.Conn

  @moduledoc """
  A plug to validate required fields dynamically.

  Options:
    - :fields - a list of atoms or nested maps specifying required keys
      Example:
        [ :name, %{user: [:id, :email]} ]
  """

  def init(opts), do: opts

  def call(conn, opts) do
    fields = Keyword.fetch!(opts, :fields)

    case check_fields(conn.body_params, fields) do
      :ok ->
        conn

      {:error, missing} ->
        conn
        |> put_status(:bad_request)
        |> Phoenix.Controller.json(%{error: "Missing required fields", missing: missing})
        |> halt()
    end
  end

  defp check_fields(params, fields) when is_list(fields) do
    missing =
      fields
      |> Enum.flat_map(&check_fields(params, &1))

    if missing == [], do: :ok, else: {:error, missing}
  end

  defp check_fields(params, field) when is_atom(field) do
    if Map.has_key?(params, Atom.to_string(field)) or Map.has_key?(params, field) do
      []
    else
      [field]
    end
  end

  defp check_fields(params, field_map) when is_map(field_map) do
    [{key, nested_fields}] = Map.to_list(field_map)

    value = Map.get(params, Atom.to_string(key)) || Map.get(params, key)

    if is_map(value) do
      check_fields(value, nested_fields)
    else
      [key]
    end
  end
end
