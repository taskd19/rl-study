defmodule RlStudy.MDP.EnvironmentDemoTest do
  require Logger
  use ExUnit.Case
  alias RlStudy.MDP.Agent
  alias RlStudy.MDP.Environment

  test "MDP demo" do
    grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
    env = Environment.new(grid)
    agent = Agent.new(env)
    Logger.debug("env: #{inspect(env)}")
    Logger.debug("agent: #{inspect(agent)}")

    state = Environment.reset(env)
    total_reward = 0
    done = false

    action = Agent.policy(agent, state)
    # next_s = Environment.step(env, action)
    # Logger.debug("next_s: #{inspect(next_s)}")
    # for i <- 0..9 do
    #   state = Environment.reset(env)
    #   total_reward = 0
    #   done = false

    # TODO while loop https://codingwithalchemy.com/using-while-loops-in-elixir/
    #   # while !done do
    #   # end
    # end
  end
end
