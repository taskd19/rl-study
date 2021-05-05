defmodule RlStudy.DP.ValueIterationPlanner do
  alias RlStudy.DP.Planner
  alias RlStudy.MDP.Environment
  require Logger

  @type t :: %RlStudy.DP.ValueIterationPlanner{
          env: RlStudy.MDP.Environment.t(),
          log: [String.t()]
        }
  defstruct Planner.planner_data()

  defimpl RlStudy.DP.Planner.Plan, for: RlStudy.DP.ValueIterationPlanner do
    @spec plan(RlStudy.DP.ValueIterationPlanner.t(), float(), float()) :: float()
    def plan(planner, gamma \\ 0.9, threshold \\ 0.0001) do
      init_planner = Planner.initialize(planner)
      Logger.info("planner: #{inspect(init_planner, pretty: true)}")

      v =
        Environment.states(init_planner.env)
        |> Map.new(fn v -> {v, 0} end)

      Logger.debug("v: #{inspect(v, pretty: true)}")

      {:ok, updated_planner, updated_v} = calc(planner, gamma, threshold, v, 0)
      Planner.dict_to_grid(updated_planner, updated_v)
    end

    defp calc(planner, gamma, threshold, v, delta) do
      Logger.debug("v: #{inspect(v, pretty: true)}")
      Logger.debug("delta: #{inspect(delta, pretty: true)}")
      planner_updated = %{planner | log: planner.log ++ [Planner.dict_to_grid(planner, v)]}

      %{v: v_updated, delta: delta_updated} =
        Enum.reduce(v, %{v: v, delta: delta}, fn {v_state, _v_reward}, acc ->
          if Environment.can_action_at(planner.env, v_state) do
            max_reward = max_reward(planner_updated, gamma, acc.v, v_state)

            Logger.debug("max_reward: #{inspect(max_reward, pretty: true)}")
            Logger.debug("acc.delta: #{inspect(acc.delta, pretty: true)}")
            Logger.debug("acc.v: #{inspect(acc.v, pretty: true)}")
            Logger.debug("v_state: #{inspect(v_state, pretty: true)}")

            delta_updating = Enum.max([acc.delta, Kernel.abs(max_reward - acc.v[v_state])])
            v_updating = Map.update(acc.v, v_state, max_reward, fn _value -> max_reward end)
            %{v: v_updating, delta: delta_updating}
          else
            %{v: acc.v, delta: acc.delta}
          end
        end)

      if delta_updated >= threshold do
        calc(planner_updated, gamma, threshold, v_updated, 0)
      else
        {:ok, planner_updated, v_updated}
      end
    end

    defp max_reward(planner, gamma, v, state) do
      Environment.actions()
      |> Enum.map(fn action ->
        transitions = Planner.transitions_at(planner, state, action)

        Enum.reduce(transitions, 0, fn %{prob: prob, next_state: state, reward: reward}, r ->
          r + prob * (reward + gamma * v[state])
        end)
      end)
      |> Enum.max()
    end
  end
end
