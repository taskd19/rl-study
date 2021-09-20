defmodule RlStudy.DP.PolicyIterationPlannerTest do
  alias RlStudy.DP.PolicyIterationPlanner
  alias RlStudy.MDP.Environment
  require Logger
  use ExUnit.Case

  test "init test" do
    IO.puts(
      inspect(
        PolicyIterationPlanner.initialize(%PolicyIterationPlanner{
          env: Environment.new([[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]),
          log: []
        }),
        pretty: true
      )
    )
  end
end
