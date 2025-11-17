defmodule DashboardApiWeb.Plugs.ValidateBody do
  import Plug.Conn

  @moduledoc """
  A plug to validate required fields dynamically.

  Options:
    - :fields - a list of atoms or nested maps specifying required keys
    - :only - optional list of actions to run the plug for
    - :except - optional list of actions to skip the plug
  """

  def init(opts), do: opts

  def call(conn, opts) do
    action = conn.private[:phoenix_action]

    cond do
      only = opts[:only] -> unless action in only, do: conn, else: run_check(conn, opts)
      except = opts[:except] -> if action in except, do: conn, else: run_check(conn, opts)
      true -> run_check(conn, opts)
    end
  end

  defp run_check(conn, opts) do
    fields = Keyword.fetch!(opts, :fields)

    params = Map.merge(conn.params, conn.body_params)

    case check_fields(params, fields) do
      :ok -> conn
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
