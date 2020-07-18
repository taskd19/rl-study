defmodule RlStudy.DP.Planner do
  @type t :: %RlStudy.DP.Planner{
          env: RlStudy.MDP.Environment.t(),
          log: [String.t()]
        }
  defstruct [:env, :log]

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
end
