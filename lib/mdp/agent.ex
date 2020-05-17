defmodule RlStudy.MDP.Agent do
  @type t :: %RlStudy.MDP.Agent{actions: [RlStudy.MDP.Action.t()]}
  defstruct [:actions]

  @doc """
  # Examples
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> env = RlStudy.MDP.Environment.new(grid)
      iex> agent = RlStudy.MDP.Agent.new(env)
      %RlStudy.MDP.Agent{actions: [:up, :down, :left, :right]}
  """
  @spec new(RlStudy.MDP.Environment.t()) :: RlStudy.MDP.Agent.t()
  def new(_environment) do
    %RlStudy.MDP.Agent{actions: RlStudy.MDP.Environment.actions()}
  end

  @spec policy(RlStudy.MDP.Agent.t(), RlStudy.MDP.State.t()) :: RlStudy.MDP.Action.t()
  def policy(agent, _state) do
    Enum.take_random(agent.actions, 1)
    |> Enum.at(0)
  end
end
