defmodule RlStudy.D1.Environment do
  alias RlStudy.D1.State
  alias RlStudy.D1.Action

  defstruct [:grid, :agent_state, :move_probe, :default_reward]

  def new(grid, move_probe) do
    %RlStudy.D1.Environment{
      grid: grid,
      agent_state: State.new(),
      default_reward: -0.04,
      move_probe: move_probe
    }
  end

  def row_length(environment) do
    length(environment.grid)
  end

  def column_length(environment) do
    length(environment.grid[0])
  end

  def actions() do
    [Action.up(), Action.down(), Action.left(), Action.right()]
  end

  def states(environment) do
    environment.grid
    |> Enum.with_index()
    |> Enum.map(fn {row, index_row} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {cell, index_column} ->
        if(cell != 9) do
          State.new(index_row, index_column)
        end
      end)
    end)
    |> List.flatten()
    |> Enum.filter(fn elm -> elm != nil end)
  end
end
