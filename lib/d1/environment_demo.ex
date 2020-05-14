defmodule RlStudy.D1.EnvironmentDemo do
  alias RlStudy.D1.Agent
  alias RlStudy.D1.Environment

  def demo() do
    grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
    env = Environment.new(grid)
    agent = Agent.new(env)
    IO.inspect(agent)

    state = Environment.reset(env)
    total_reward = 0
    done = false

    action = Agent.policy(agent, state)
    next_s = Environment.step(env, action)
    IO.inspect(next_s)
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
