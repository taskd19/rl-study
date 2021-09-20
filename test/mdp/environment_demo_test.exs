defmodule RlStudy.MDP.EnvironmentDemoTest do
  require Logger
  use ExUnit.Case
  alias RlStudy.MDP.Agent
  alias RlStudy.MDP.Environment

  test "MDP demo" do
    grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
    env = Environment.new(grid)
    agent = Agent.new(env)
    Logger.info("env: #{inspect(env)}")
    Logger.info("agent: #{inspect(agent)}")

    for episode <- 0..9 do
      run_game(episode, env, agent)
    end
  end

  def run_game(episode, env, agent) do
    init_env = Environment.reset(env)

    game_step(
      step: 0,
      episode: episode,
      env: init_env,
      agent: agent,
      state: init_env.agent_state,
      total_reward: 0,
      done: false
    )
  end

  def game_step(
        step: step,
        episode: episode,
        env: env,
        agent: agent,
        state: state,
        total_reward: total_reward,
        done: done
      )
      when done == true do
    IO.puts(
      "Episode #{inspect(episode)}: Agent gets #{inspect(total_reward)} reward. state: #{
        inspect(state)
      }, step: #{inspect(step)}"
    )
  end

  def game_step(
        step: step,
        episode: episode,
        env: env,
        agent: agent,
        state: state,
        total_reward: total_reward,
        done: done
      ) do
    Logger.debug(
      "game[#{step}] -> env: #{inspect(env)}, state: #{inspect(state)}, total_reward: #{
        inspect(total_reward)
      }, done: #{inspect(done)}"
    )

    action = Agent.policy(agent, state)

    %{environment: next_env, next_state: next_state, reward: reward, done: done_step} =
      Environment.step(env, action)

    Logger.debug(
      "action: #{inspect(action)}, next_state: #{inspect(next_state)}, reward: #{inspect(reward)}, doen_step: #{
        inspect(done_step)
      }"
    )

    game_step(
      step: step + 1,
      episode: episode,
      env: next_env,
      agent: agent,
      state: next_state,
      total_reward: total_reward + reward,
      done: done_step
    )
  end
end
