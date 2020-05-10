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

  def transit_func(environment, state, action) do
    transition_probes = []

    if !can_action_at(environment, state) do
      transition_probes
    end

    opsite_direction = Action.opsite_action(action)

    environment.actions()
    |> Enum.reduce(transition_probes, fn a, acc ->
      next_state = move(environment, state, a)

      # https://elixir-lang.org/getting-started/pattern-matching.html#the-pin-operator
      Map.update(acc, next_state, 0, fn value ->
        case a do
          ^action -> value + environment.move_prob
          ^opsite_direction -> value + (1 - environment.move_prob) / 2
        end
      end)
    end)
  end

  def can_action_at(environment, state) do
    environment.grid[state.row][state.column] == 0
  end

  defp move(environment, state, action) do
    if !can_action_at(environment, state) do
      raise "Can't move from here!"
    end

    next_state = State.clone(state)

    # Move
    next_state =
      cond do
        action == Action.up() -> %{next_state | row: next_state.row - 1}
        action == Action.down() -> %{next_state | row: next_state.row + 1}
        action == Action.left() -> %{next_state | column: next_state.column + 1}
        action == Action.right() -> %{next_state | column: next_state.column + 1}
      end

    next_state =
      cond do
        # Check if next_state is not out of the grid
        !(0 <= next_state.row && next_state.row < row_length(environment)) -> state
        !(0 <= next_state.column && next_state.column < column_length(environment)) -> state
        # Check whether the agent bumped a block cell.
        environment.grid[next_state.row][next_state.column] == 9 -> state
        true -> next_state
      end

    next_state
  end
end
