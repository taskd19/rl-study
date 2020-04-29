defmodule RlStudy.D1.State do
  defstruct row: 0, column: 0

  def _repr_(state) do
    IO.puts("<State: [#{state.row}, #{state.column}]>")
  end
end
