defmodule DashboardApiWeb.Plugs.ConvertToNumericParams do
  @moduledoc """
  Converts params ending in `_id` from strings to integers.
  """

  def init(opts), do: opts

  def call(%Plug.Conn{params: params} = conn, _opts) do
    converted_params =
      Enum.reduce(params, %{}, fn {key, value}, acc ->
        if ends_with_id?(key) do
          Map.put(acc, key, to_int(value))
        else
          Map.put(acc, key, value)
        end
      end)

    %{conn | params: converted_params}
  end

  defp ends_with_id?(key) when is_binary(key) do
    String.ends_with?(key, "_id")
  end

  defp ends_with_id?(_), do: false

  defp to_int(value) when is_binary(value) do
    case Integer.parse(value) do
      {num, ""} -> num
      _ -> value
    end
  end

  defp to_int(value), do: value
end
