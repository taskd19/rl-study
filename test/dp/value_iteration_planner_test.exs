defmodule RlStudy.DP.ValueIterationPlannerTest do
  alias RlStudy.DP.Planner
  alias RlStudy.DP.ValueIterationPlanner
  alias RlStudy.MDP.Environment
  require Logger
  use ExUnit.Case

  test "simple trial" do
    IO.puts(
      inspect(
        Planner.Plan.plan(
          %ValueIterationPlanner{
            env: Environment.new([[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]),
            log: []
          },
          0.9,
          0.0001
        ),
        pretty: true
      )
    )
  end
end
