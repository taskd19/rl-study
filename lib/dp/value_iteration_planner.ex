defmodule RlStudy.DP.ValueIterationPlanner do
  alias RlStudy.DP.Planner

  @type t :: %RlStudy.DP.ValueIterationPlanner{
          env: RlStudy.MDP.Environment.t(),
          log: [String.t()]
        }
  defstruct [:env, :log]

  defimpl RlStudy.DP.Planner.Plan, for: RlStudy.DP.ValueIterationPlanner do
    @spec plan(RlStudy.DP.ValueIterationPlanner.t(), float(), float()) :: float()
    def plan(planner, gamma \\ 0.9, threshold \\ 0.0001) do
      init_planner = Planner.initialize(planner)
      actions = planner.env.actions

      # TODO impl
      0.0
    end
  end
end
