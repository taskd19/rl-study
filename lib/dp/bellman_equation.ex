defmodule RlStudy.DP.BellmanEquation do
  @moduledoc """
  Value base
  """

  require Logger

  @spec v(String.t(), float()) :: float()
  def v(s, gamma \\ 0.99) do
    Logger.info("v: #{inspect(s)}")
    v = r(s) + gamma * max_v_on_next_state(s)
    Logger.info("v: #{inspect(s)} -> #{inspect(v)}")
    v
  end

  @spec r(String.t()) :: -1 | 0 | 1
  def r(s) do
    case s do
      "happy_end" -> 1
      "bad_end" -> -1
      _ -> 0
    end
  end

  @spec max_v_on_next_state(String.t()) :: float()
  def max_v_on_next_state(s) do
    Logger.debug("max_v_on_next_state: #{inspect(s)}")

    if(Enum.member?(["happy_end", "bad_end"], s)) do
      # game end, the expected value is 0.
      0
    else
      ["up", "down"]
      |> Enum.map(fn a ->
        Logger.debug("state=#{inspect(s)}, action=#{inspect(a)}")

        transit_func(s, a)
        |> (fn transit_probes ->
              Logger.debug("transit_probes=#{inspect(transit_probes)}")
              transit_probes
            end).()
        |> Enum.reduce(0, fn {next_state, prob}, acc ->
          acc + prob * v(next_state)
        end)
        |> (fn value ->
              Logger.debug("value: #{inspect(s)} + #{inspect(a)} -> #{inspect(value)}")
              value
            end).()
      end)
      |> (fn values ->
            Logger.debug("values: #{inspect(values)}")
            values
          end).()
      |> Enum.max()
    end
    |> (fn v ->
          Logger.debug("max_v_on_next_state: state=#{inspect(s)} -> #{inspect(v)}")
          v
        end).()
  end

  @spec transit_func(String.t(), String.t()) :: %{String.t() => float()}
  def transit_func(state, action) do
    Logger.debug("transit_func: state=#{inspect(state)}, action=#{inspect(action)}")

    [_ | actions] = String.split(state, "_")
    limit_game_count = 5
    happy_end_border = 4
    move_prob = 0.9

    if length(actions) == limit_game_count do
      up_count = actions |> Enum.filter(fn a -> a == "up" end) |> Enum.count()

      if up_count >= happy_end_border do
        Map.new() |> Map.put("happy_end", 1.0)
      else
        Map.new() |> Map.put("bad_end", 1.0)
      end
    else
      opposite = if action == "down", do: "up", else: "down"

      Map.new()
      |> Map.put(next_state(state, action), move_prob)
      |> Map.put(next_state(state, opposite), 1 - move_prob)
    end
  end

  defp next_state(state, action) do
    state <> "_" <> action
  end
end
