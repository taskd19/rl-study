defmodule RlStudy.D1.State do
  defstruct row: -1, column: -1

  def new() do
    %RlStudy.D1.State{}
  end

  def new(row, column) when is_integer(row) and is_integer(column) do
    %RlStudy.D1.State{row: row, column: column}
  end

  def new(value) when is_map(value) do
    new(value.row, value.column)
  end

  def repr(state) do
    "<State: [#{state.row}, #{state.column}]>"
  end

  def clone(state) do
    new(%{row: state.row, column: state.column})
  end

  def hash(state) do
    :crypto.hash(:sha256, repr(state)) |> Base.encode64()
  end

  def eq(state1, state2) do
    state1 == state2
  end
end
