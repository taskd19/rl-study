defmodule RlStudy.DP.Planner do
  alias RlStudy.MDP.Environment
  require Logger
  require Matrix

  @planner_data [env: nil, log: nil]

  @type t :: %RlStudy.DP.Planner{
          env: RlStudy.MDP.Environment.t(),
          log: [String.t()]
        }
  defstruct @planner_data

  def planner_data() do
    @planner_data
  end

  @spec initialize(RlStudy.DP.Planner.t()) :: RlStudy.DP.Planner.t()
  def initialize(planner) do
    %RlStudy.DP.Planner{env: RlStudy.MDP.Environment.reset(planner.env), log: []}
  end

  defprotocol Plan do
    @fallback_to_any true
    def plan(planner, gamma \\ 0.9, threshold \\ 0.0001)
  end

  defimpl Plan, for: Any do
    @spec plan(any, any, any) :: none
    def plan(_planner, _gamma \\ 0.9, _threshold \\ 0.0001) do
      raise "Planner have to implements plan method."
    end
  end

  @spec transitions_at(
          RlStudy.DP.Planner.t(),
          RlStudy.MDP.State.t(),
          RlStudy.MDP.Action.t()
        ) :: [%{prob: float(), next_state: RlStudy.MDP.State.t(), reward: float()}]
  def transitions_at(planner, state, action) do
    Logger.debug(
      "planner: #{inspect(planner, pretty: true)}, state: #{inspect(state, pretty: true)}, action: #{
        inspect(action, pretty: true)
      }"
    )

    Environment.transit_func(planner.env, state, action)
    |> Enum.map(fn {state, prob} ->
      %{reward: reward, done: _} = Environment.reward_func(planner.env, state)
      %{prob: prob, next_state: state, reward: reward}
    end)
  end

  def dict_to_grid(planner, state_reward_dict) do
    Logger.debug("planner: #{inspect(planner, pretty: true)}")
    Logger.debug("state_reward_dict: #{inspect(state_reward_dict, pretty: true)}")

    row_length = Environment.row_length(planner.env)
    column_length = Environment.column_length(planner.env)

    zero_grid = Matrix.new(row_length, column_length)
    # Enum.map(1..row_length, fn _r ->
    #   Enum.map(1..column_length, fn _c ->
    #     0
    #   end)
    # end)

    state_reward_dict
    |> Enum.reduce(zero_grid, fn {s, reward}, acc ->
      Matrix.set(acc, s.row, s.column, reward)
      # TODO check impl
      # {row, _} = List.pop_at(acc, s.row)
      # updated_row = List.update_at(row, s.column, fn _ -> s.reward end)
      # List.update_at(acc, s.row, fn _ -> updated_row end)
    end)
  end
end
