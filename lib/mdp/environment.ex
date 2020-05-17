defmodule RlStudy.MDP.Environment do
  alias RlStudy.MDP.State
  alias RlStudy.MDP.Action
  require Logger

  defstruct [:grid, :agent_state, :move_probe, :default_reward]

  def new(grid) do
    new(grid, 0.8)
  end

  def new(grid, move_probe) do
    %RlStudy.MDP.Environment{
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
    transition_probes = %{}

    if !can_action_at(environment, state) do
      transition_probes
    end

    opsite_direction = Action.opsite_action(action)

    actions()
    |> Enum.reduce(transition_probes, fn a, acc ->
      next_state = move(environment, state, a)

      # https://elixir-lang.org/getting-started/pattern-matching.html#the-pin-operator
      Map.update(acc, next_state, 0, fn value ->
        case a do
          ^action -> value + environment.move_probe
          ^opsite_direction -> value + (1 - environment.move_probe) / 2
          _ -> 0
        end
      end)
    end)
  end

  def can_action_at(environment, state) do
    environment.grid
    |> Enum.at(state.row)
    |> Enum.at(state.column)
    |> Kernel.==(0)
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

  def reward_func(environment, state) do
    case environment.grid[state.row][state.column] do
      1 -> %{reward: 1, done: true}
      -1 -> %{reward: -1, done: true}
      _ -> %{reward: environment.default_reward, done: false}
    end
  end

  def reset(environment) do
    new_env = %{environment | agent_state: State.new(row_length(environment) - 1, 0)}
    %{environment: new_env, agent_state: new_env.agent_state}
  end

  def step(environment, action) do
    %{next_state: next_state, reward: reward, done: done} =
      transit(environment, environment.agent_state, action)

    if next_state != nil do
      %{
        environment: %{environment | agent_state: next_state},
        next_state: next_state,
        reward: reward,
        done: done
      }
    else
      %{environment: environment, next_state: next_state, reward: reward, done: done}
    end
  end

  def transit(environment, state, action) do
    transit_probes = transit_func(environment, state, action)

    if Kernel.map_size(transit_probes) == 0 do
      %{environment: environment, next_state: nil, reward: nil, done: true}
    else
      %{next_states: next_states, probes: probes} =
        Enum.reduce(transit_probes, {}, fn s, acc ->
          next_states = [acc.next_states | s]
          probes = [acc.probes | transit_probes[s]]
          %{next_states: next_states, probes: probes}
        end)

      # TODO
      # next_state = rando
      %{reward: reward, done: done} = reward_func(environment, state)
      %{next_state: next_states[0], reward: reward, done: done}
    end
  end
end
