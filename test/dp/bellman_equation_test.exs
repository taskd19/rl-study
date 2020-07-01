defmodule RlStudy.DP.BellmanEquationTest do
  alias RlStudy.DP.BellmanEquation
  require Logger
  use ExUnit.Case

  test "simple trial" do
    IO.puts(BellmanEquation.v("state"))
    IO.puts(BellmanEquation.v("state_up_up"))
    IO.puts(BellmanEquation.v("state_up_down_down"))
  end
end
