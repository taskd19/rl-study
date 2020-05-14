defmodule RlStudy.D1.Agent do
  defstruct [:actions]

  def new(environment) do
    %RlStudy.D1.Agent{actions: RlStudy.D1.Environment.actions()}
  end

  def policy(agent, state) do
    Enum.take_random(agent.actions, 1)
    |> Enum.at(0)
  end
end
