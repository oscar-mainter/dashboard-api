defmodule DashboardApiWeb.Plugs.NormalizeAndValidateIds do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(%Plug.Conn{params: params} = conn, _opts) do
    {valid?, converted_params, bad_keys} =
      Enum.reduce(params, {true, %{}, []}, fn {key, value}, {ok?, acc, bad_keys} ->
        if String.ends_with?(key, "_id") do
          case Integer.parse(value) do
            {num, ""} ->
              {ok?, Map.put(acc, key, num), bad_keys}

            _ ->
              {false, Map.put(acc, key, value), [key | bad_keys]}
          end
        else
          {ok?, Map.put(acc, key, value), bad_keys}
        end
      end)

      if valid? do
        %{conn | params: converted_params}
      else
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid params format", invalid_params: Enum.reverse(bad_keys)})
        |> halt()
      end
  end
end
