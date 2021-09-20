defmodule RlStudy.DP.PolicyIterationPlanner do
  alias RlStudy.DP.PolicyIterationPlanner
  alias RlStudy.DP.Planner
  alias RlStudy.MDP.Environment
  require Logger

  @type t :: %RlStudy.DP.PolicyIterationPlanner{
          env: Environment.t(),
          log: [] | [binary()],
          policy: [any()]
        }
  defstruct Planner.planner_data() ++ [policy: nil]

  @spec initialize(RlStudy.DP.PolicyIterationPlanner.t()) :: RlStudy.DP.PolicyIterationPlanner.t()
  def initialize(planner) do
    planner_initializing = Planner.initialize(planner)

    Logger.info("planner_initializing: #{inspect(planner_initializing, pretty: true)}")

    policy =
      Enum.map(Environment.states(planner_initializing.env), fn s ->
        action_map =
          Environment.actions()
          |> Enum.map(fn a ->
            {a, 1 / length(Environment.actions())}
          end)
          |> Map.new()

        {s, action_map}
      end)
      |> Map.new()

    Logger.info("policy: #{inspect(policy, pretty: true)}")

    %PolicyIterationPlanner{
      env: planner_initializing.env,
      log: planner_initializing.log,
      policy: policy
    }
  end

  @spec estimate_by_policy(
          %{:env => RlStudy.MDP.Environment.t(), optional(any) => any},
          float(),
          float()
        ) :: float()
  def estimate_by_policy(planner, gamma, threshold) do
    v =
      Environment.states(planner.env)
      |> Enum.map(fn s ->
        {s, 0}
      end)
      |> Map.new()

    {:ok, v_updated} = calc_v(planner, gamma, threshold, v, 0)
    v_updated
  end

  def calc_v(planner, gamma, threshold, v, delta) do
    %{v: v_updated, delta: delta_updated} =
      Enum.reduce(v, %{v: v, delta: delta}, fn {v_state, _v_reward}, acc ->
        max_reward = max_reward(planner, gamma, v, v_state)
        delta_updating = Enum.max([acc.delta, Kernel.abs(max_reward - acc.v[v_state])])
        v_updating = Map.update(acc.v, v_state, max_reward, fn _value -> max_reward end)
        %{v: v_updating, delta: delta_updating}
      end)

    if delta_updated >= threshold do
      calc_v(planner, gamma, threshold, v_updated, 0)
    else
      {:ok, v_updated}
    end
  end

  @spec max_reward(
          atom | %{:policy => nil | maybe_improper_list | map, optional(any) => any},
          float(),
          map(),
          binary()
        ) :: float()
  def max_reward(planner, gamma, v, state) do
    planner.policy[state]
    |> Enum.map(fn {action, action_prob} ->
      transitions = Planner.transitions_at(planner, state, action)

      Enum.reduce(transitions, 0, fn %{prob: prob, next_state: state, reward: reward}, r ->
        r + action_prob * prob * (reward + gamma * v[state])
      end)
    end)
    |> Enum.max()
  end

  defimpl RlStudy.DP.Planner.Plan, for: RlStudy.DP.PolicyIterationPlanner do
    @spec plan(RlStudy.DP.PolicyIterationPlanner.t(), float(), float()) :: float()
    def plan(planner, gamma \\ 0.9, threshold \\ 0.0001) do
      init_planner = Planner.initialize(planner)
      Logger.info("planner: #{inspect(init_planner, pretty: true)}")

      states = Environment.states(init_planner.env)
      actions = Environment.actions()
      {:ok, updated_planner, updated_v} = calc(planner, gamma, threshold, states)
      Planner.dict_to_grid(updated_planner, updated_v)
    end

    def take_max_action(action_value_dict) do
      Enum.max_by(action_value_dict, fn {_k, v} -> v end)
    end

    @spec calc(
            %{:env => RlStudy.MDP.Environment.t(), :log => list, optional(any) => any},
            float,
            float,
            any
          ) :: {:ok, %{:env => map, :log => [...], optional(any) => any}, float}
    def calc(planner, gamma, threshold, states) do
      v = PolicyIterationPlanner.estimate_by_policy(planner, gamma, threshold)
      planner_updated = %{planner | log: planner.log ++ [Planner.dict_to_grid(planner, v)]}

      %{policy: updated_policy, update_stable: update_stable} =
        Enum.reduce(states, %{policy: planner.policy, update_stable: true}, fn {state, action_map},
                                                                               acc ->
          policy_action = take_max_action(planner.policy[state])

          best_action =
            Enum.reduce(Environment.actions(), %{}, fn a, acc ->
              r =
                Enum.reduce(planner.transitions_at(state, a), 0, fn {prob, next_state, reward},
                                                                    acc ->
                  acc + prob * (reward + gamma * v[next_state])
                end)

              Map.put(acc, a, r)
            end)
            |> take_max_action()

          update_stable = policy_action == best_action

          updated_policy =
            Enum.reduce(planner.policy[state], planner.policy, fn a, acc ->
              updated_policy_s =
                Map.put(planner.policy[state], a, if(a == best_action, do: 1, else: 0))

              Map.put(acc, state, updated_policy_s)
            end)

          %{acc | policy: updated_policy, update_stable: update_stable}
          nil
        end)

      planner_updated = %{planner_updated | policy: updated_policy}

      if update_stable do
        {:ok, planner_updated, v}
      else
        calc(planner_updated, gamma, threshold, updated_policy)
      end
    end
  end
end
