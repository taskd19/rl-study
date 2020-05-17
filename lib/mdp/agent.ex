defmodule RlStudy.MDP.Agent do
  defstruct [:actions]

  def new(environment) do
    %RlStudy.MDP.Agent{actions: RlStudy.MDP.Environment.actions()}
  end

  def policy(agent, state) do
    # TODO
    Enum.take_random(agent.actions, 1)
    |> Enum.at(0)
  end
end
