defmodule RlStudy.MDP.Environment do
  alias RlStudy.MDP.State
  alias RlStudy.MDP.Action
  require Logger

  @type grid_t :: [[integer]]
  @type t :: %RlStudy.MDP.Environment{
          grid: grid_t(),
          agent_state: RlStudy.MDP.State.t(),
          move_probe: float,
          default_reward: float
        }
  defstruct [:grid, :agent_state, :move_probe, :default_reward]

  @doc """
  # Examples
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> RlStudy.MDP.Environment.new(grid)
      %RlStudy.MDP.Environment{
        agent_state: %RlStudy.MDP.State{column: -1, row: -1},
        default_reward: -0.04,
        grid: [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]],
        move_probe: 0.8
      }
  """
  @spec new(grid_t()) :: RlStudy.MDP.Environment.t()
  def new(grid) do
    new(grid, 0.8)
  end

  @doc """
  # Examples
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> RlStudy.MDP.Environment.new(grid, 0.3)
      %RlStudy.MDP.Environment{
        agent_state: %RlStudy.MDP.State{column: -1, row: -1},
        default_reward: -0.04,
        grid: [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]],
        move_probe: 0.3
      }
  """
  @spec new(grid_t(), float) :: RlStudy.MDP.Environment.t()
  def new(grid, move_probe) do
    %RlStudy.MDP.Environment{
      grid: grid,
      agent_state: State.new(),
      default_reward: -0.04,
      move_probe: move_probe
    }
  end

  @doc """
  # Examples
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> env = RlStudy.MDP.Environment.new(grid)
      iex> RlStudy.MDP.Environment.row_length(env)
      3
  """
  @spec row_length(t()) :: non_neg_integer()
  def row_length(environment) do
    length(environment.grid)
  end

  @doc """
  # Examples
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> env = RlStudy.MDP.Environment.new(grid)
      iex> RlStudy.MDP.Environment.column_length(env)
      4
  """
  @spec column_length(t()) :: non_neg_integer()
  def column_length(environment) do
    environment.grid
    |> Enum.at(0)
    |> length()
  end

  @doc """
  # Examples
      iex> RlStudy.MDP.Environment.actions()
      [:up, :down, :left, :right]
  """
  @spec actions :: [RlStudy.MDP.Action.t()]
  def actions() do
    [Action.up(), Action.down(), Action.left(), Action.right()]
  end

  @doc """
  # Examples
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> env = RlStudy.MDP.Environment.new(grid)
      iex> RlStudy.MDP.Environment.states(env)
      [
        %RlStudy.MDP.State{column: 0, row: 0},
        %RlStudy.MDP.State{column: 1, row: 0},
        %RlStudy.MDP.State{column: 2, row: 0},
        %RlStudy.MDP.State{column: 3, row: 0},
        %RlStudy.MDP.State{column: 0, row: 1},
        %RlStudy.MDP.State{column: 2, row: 1},
        %RlStudy.MDP.State{column: 3, row: 1},
        %RlStudy.MDP.State{column: 0, row: 2},
        %RlStudy.MDP.State{column: 1, row: 2},
        %RlStudy.MDP.State{column: 2, row: 2},
        %RlStudy.MDP.State{column: 3, row: 2}
      ]
  """
  @spec states(RlStudy.MDP.Environment.t()) :: [RlStudy.MDP.State.t()]
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

  @doc """
  # Examples
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> env = RlStudy.MDP.Environment.new(grid)
      iex> state = RlStudy.MDP.State.new(2,0)
      iex> RlStudy.MDP.Environment.transit_func(env, state, :up)
      %{%RlStudy.MDP.State{column: 0, row: 1} => 0.8, %RlStudy.MDP.State{column: 0, row: 2} => 0.09999999999999998, %RlStudy.MDP.State{column: 1, row: 2} => 0.09999999999999998}
      iex> RlStudy.MDP.Environment.transit_func(env, state, :right)
      %{%RlStudy.MDP.State{column: 0, row: 1} => 0.09999999999999998, %RlStudy.MDP.State{column: 0, row: 2} => 0.09999999999999998, %RlStudy.MDP.State{column: 1, row: 2} => 0.8}
      iex> RlStudy.MDP.Environment.transit_func(env, state, :down)
      %{%RlStudy.MDP.State{column: 0, row: 1} => 0, %RlStudy.MDP.State{column: 0, row: 2} => 0.9, %RlStudy.MDP.State{column: 1, row: 2} => 0.09999999999999998}
      iex> RlStudy.MDP.Environment.transit_func(env, state, :left)
      %{%RlStudy.MDP.State{column: 0, row: 1} => 0.09999999999999998, %RlStudy.MDP.State{column: 0, row: 2} => 0.9, %RlStudy.MDP.State{column: 1, row: 2} => 0}
  """
  @spec transit_func(
          RlStudy.MDP.Environment.t(),
          RlStudy.MDP.State.t(),
          RlStudy.MDP.Action.t()
        ) :: %{optional(RlStudy.MDP.Action.t()) => float}
  def transit_func(environment, state, action) do
    Logger.debug("Transit. state: #{inspect(state)}, action: #{inspect(action)}")

    transition_probes = %{}

    if !can_action_at(environment, state) do
      transition_probes
    end

    oposite_direction = Action.opsite_action(action)
    Logger.debug("oposite_direction: #{inspect(oposite_direction)}")

    actions()
    |> Enum.reduce(transition_probes, fn a, acc ->
      Logger.debug("Update probes. action: #{inspect(a)}, transit_probes: #{inspect(acc)}")

      next_state = move(environment, state, a)

      probe =
        cond do
          a == action -> environment.move_probe
          a != oposite_direction -> (1 - environment.move_probe) / 2
          true -> 0
        end

      Logger.debug("next_state: #{inspect(next_state)}, probe: #{probe}")

      # https://elixir-lang.org/getting-started/pattern-matching.html#the-pin-operator
      Map.update(acc, next_state, probe, fn value ->
        value + probe
      end)
    end)
  end

  @doc """
  # Examples
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> env = RlStudy.MDP.Environment.new(grid)
      iex> state = RlStudy.MDP.State.new(0,0)
      iex> RlStudy.MDP.Environment.can_action_at(env, state)
      true
      iex> state2 = RlStudy.MDP.State.new(1,1)
      iex> RlStudy.MDP.Environment.can_action_at(env, state2)
      false
  """
  @spec can_action_at(RlStudy.MDP.Environment.t(), RlStudy.MDP.State.t()) :: boolean
  def can_action_at(environment, state) do
    environment.grid
    |> Enum.at(state.row)
    |> Enum.at(state.column)
    |> Kernel.==(0)
  end

  defp move(environment, state, action) do
    Logger.debug(
      "environment: #{inspect(environment)}, state: #{inspect(state)}, action: #{inspect(action)}"
    )

    if !can_action_at(environment, state) do
      raise "Can't move from here!"
    end

    next_state = State.clone(state)

    # Move
    next_state =
      cond do
        action == Action.up() -> %{next_state | row: next_state.row - 1}
        action == Action.down() -> %{next_state | row: next_state.row + 1}
        action == Action.left() -> %{next_state | column: next_state.column - 1}
        action == Action.right() -> %{next_state | column: next_state.column + 1}
      end

    next_state =
      cond do
        # Check if next_state is not out of the grid
        !(0 <= next_state.row && next_state.row < row_length(environment)) ->
          state

        !(0 <= next_state.column && next_state.column < column_length(environment)) ->
          state

        # Check whether the agent bumped a block cell.
        environment.grid |> Enum.at(next_state.row) |> Enum.at(next_state.column) |> Kernel.==(9) ->
          state

        true ->
          next_state
      end

    next_state
  end

  @doc """
  # Examples
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> env = RlStudy.MDP.Environment.new(grid)
      iex> state = RlStudy.MDP.State.new(0,0)
      iex> RlStudy.MDP.Environment.reward_func(env, state)
      %{reward: -0.04, done: false}
      iex> state_goal = RlStudy.MDP.State.new(0,3)
      iex> RlStudy.MDP.Environment.reward_func(env, state_goal)
      %{reward: 1, done: true}
      iex> state_damage = RlStudy.MDP.State.new(1,3)
      iex> RlStudy.MDP.Environment.reward_func(env, state_damage)
      %{reward: -1, done: true}
  """
  @spec reward_func(
          RlStudy.MDP.Environment.t(),
          RlStudy.MDP.State.t()
        ) :: %{done: boolean, reward: float}
  def reward_func(environment, state) do
    case environment.grid |> Enum.at(state.row) |> Enum.at(state.column) do
      1 -> %{reward: 1, done: true}
      -1 -> %{reward: -1, done: true}
      _ -> %{reward: environment.default_reward, done: false}
    end
  end

  @doc """
  # Examples
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> env = RlStudy.MDP.Environment.new(grid)
      iex> RlStudy.MDP.Environment.reset(env)
      %{
        agent_state: %RlStudy.MDP.State{column: 0, row: 2},
        environment: %RlStudy.MDP.Environment{
          agent_state: %RlStudy.MDP.State{column: 0, row: 2},
          default_reward: -0.04,
          grid: [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]],
          move_probe: 0.8
        }
      }
  """
  @spec reset(RlStudy.MDP.Environment.t()) :: %{
          agent_state: RlStudy.MDP.State.t(),
          environment: RlStudy.MDP.Environment.t()
        }
  def reset(environment) do
    new_env = %{environment | agent_state: State.new(row_length(environment) - 1, 0)}
    %{environment: new_env, agent_state: new_env.agent_state}
  end

  @doc """
  TODO
  # Examples
      iex>
      iex> :rand.seed(:exrop, {103, 104, 105})
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> env = RlStudy.MDP.Environment.new(grid)
      iex> env = %{env | agent_state: RlStudy.MDP.State.new(2,0)}
      iex> RlStudy.MDP.Environment.step(env, :up)
      %{
        done: false,
        environment: %RlStudy.MDP.Environment{agent_state: %RlStudy.MDP.State{column: 0, row: 1}, default_reward: -0.04, grid: [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]], move_probe: 0.8},
        next_state: %RlStudy.MDP.State{column: 0, row: 1},
        reward: -0.04
      }
      iex> env = %{env | agent_state: RlStudy.MDP.State.new(0,2)}
      iex> RlStudy.MDP.Environment.step(env, :right)
      %{
        done: true,
        environment: %RlStudy.MDP.Environment{agent_state: %RlStudy.MDP.State{column: 3, row: 0}, default_reward: -0.04, grid: [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]], move_probe: 0.8},
        next_state: %RlStudy.MDP.State{column: 3, row: 0},
        reward: 1
      }
  """
  @spec step(RlStudy.MDP.Environment.t(), RlStudy.MDP.Action.t()) :: %{
          done: boolean,
          environment: RlStudy.MDP.Environment.t(),
          next_state: RlStudy.MDP.State.t(),
          reward: float
        }
  def step(environment, action) do
    %{next_state: next_state, reward: reward, done: done} =
      transit(environment, environment.agent_state, action)

    %{
      environment: %{environment | agent_state: next_state},
      next_state: next_state,
      reward: reward,
      done: done
    }
  end

  @doc """
  # Examples
      iex> :rand.seed(:exrop, {101, 102, 103})
      iex> grid = [[0, 0, 0, 1], [0, 9, 0, -1], [0, 0, 0, 0]]
      iex> env = RlStudy.MDP.Environment.new(grid)
      iex> init_state = RlStudy.MDP.State.new(2,0)
      iex> RlStudy.MDP.Environment.transit(env, init_state, :up)
      %{next_state: %RlStudy.MDP.State{column: 0, row: 1}, reward: -0.04, done: false}
      iex> goal_state = RlStudy.MDP.State.new(0,3)
      iex> RlStudy.MDP.Environment.transit(env, goal_state, :up)
      ** (RuntimeError) Can't move from here!
  """
  @spec transit(RlStudy.MDP.Environment.t(), RlStudy.MDP.State.t(), RlStudy.MDP.Action.t()) ::
          %{done: boolean, next_state: RlStudy.MDP.State.t(), reward: float}
  def transit(environment, state, action) do
    transit_probes = transit_func(environment, state, action)

    if Kernel.map_size(transit_probes) == 0 do
      Logger.debug("No transit_probes.")
      %{environment: environment, next_state: nil, reward: nil, done: true}
    else
      Logger.debug("transit_probes: #{inspect(transit_probes)}")
      next_state = prob_choice(transit_probes, :rand.uniform())
      %{reward: reward, done: done} = reward_func(environment, next_state)

      transit_to = %{next_state: next_state, reward: reward, done: done}
      Logger.debug("Transit to #{inspect(transit_to)}")
      transit_to
    end
  end

  defp prob_choice(probes, _) when Kernel.map_size(probes) == 1 do
    probe = Enum.at(Map.keys(probes), 0)
    Logger.debug("choice last one. probe: #{inspect(probe)}")
    probe
  end

  defp prob_choice(probes, ran) when Kernel.map_size(probes) > 1 do
    """
    Algorithm https://rosettacode.org/wiki/Probabilistic_choice#Elixir
    Run :rand.seed(:exrop, {101, 102, 103}) for test https://github.com/elixir-lang/elixir/blob/v1.10/lib/elixir/lib/enum.ex#L1985-L1991
    """

    Logger.debug("probes: #{inspect(probes)}, ran: #{ran}")
    state_key = Enum.at(Map.keys(probes), 0)
    {:ok, prob} = Map.fetch(probes, state_key)

    if ran < prob do
      Logger.debug("choiced prob: #{inspect(state_key)}")
      state_key
    else
      prob_choice(Map.delete(probes, state_key), ran - prob)
    end
  end
end
