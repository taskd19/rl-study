defmodule RlStudy.MDP.State do
  @typedoc """
  Custom type of State.
  """
  @type t :: %RlStudy.MDP.State{row: integer, column: integer}
  defstruct row: -1, column: -1

  @doc """
  # Examples
      iex> RlStudy.MDP.State.new()
      %RlStudy.MDP.State{}
  """
  @spec new :: RlStudy.MDP.State.t()
  def new() do
    %RlStudy.MDP.State{}
  end

  @doc """
  # Examples
      iex> RlStudy.MDP.State.new(1, 2)
      %RlStudy.MDP.State{row: 1, column: 2}
  """
  @spec new(non_neg_integer(), non_neg_integer()) :: RlStudy.MDP.State.t()
  def new(row, column) when is_integer(row) and is_integer(column) do
    %RlStudy.MDP.State{row: row, column: column}
  end

  @doc """
  # Examples
      iex> RlStudy.MDP.State.new(%{row: 7, column: 5})
      %RlStudy.MDP.State{row: 7, column: 5}
  """
  @spec new(%{row: non_neg_integer(), column: non_neg_integer()}) :: RlStudy.MDP.State.t()
  def new(value) when is_map(value) do
    new(value.row, value.column)
  end

  @doc """
  # Examples
      iex> s = RlStudy.MDP.State.new(7, 8)
      iex> RlStudy.MDP.State.repr(s)
      "<State: [7, 8]>"
  """
  @spec repr(RlStudy.MDP.State.t()) :: String.t()
  def repr(state) do
    "<State: [#{state.row}, #{state.column}]>"
  end

  @doc """
  # Examples
      iex> s = RlStudy.MDP.State.new(1,2)
      iex> RlStudy.MDP.State.clone(s)
      %RlStudy.MDP.State{row: 1, column: 2}
  """
  @spec clone(RlStudy.MDP.State.t()) :: RlStudy.MDP.State.t()
  def clone(state) do
    new(%{row: state.row, column: state.column})
  end

  @doc """
  # Examples
      iex> s = RlStudy.MDP.State.new(5, 6)
      iex> RlStudy.MDP.State.hash(s)
      "Kpo7UphjTrzxlXn1bAzT5770hacD/s/lANd61UWr87A="
  """
  @spec hash(RlStudy.MDP.State.t()) :: String.t()
  def hash(state) do
    :crypto.hash(:sha256, repr(state)) |> Base.encode64()
  end

  @doc """
      iex> s1 = RlStudy.MDP.State.new(5, 6)
      iex> s2 = RlStudy.MDP.State.new(5, 6)
      iex> s3 = RlStudy.MDP.State.new(5, 7)
      iex> RlStudy.MDP.State.eq(s1, s2)
      true
      iex> RlStudy.MDP.State.eq(s1, s3)
      false
  """
  @spec eq(RlStudy.MDP.State.t(), RlStudy.MDP.State.t()) :: boolean
  def eq(state1, state2) do
    state1 == state2
  end
end
