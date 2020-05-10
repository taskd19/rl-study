defmodule RlStudy.D1.Action do
  @moduledoc """
  ref: https://gist.github.com/smpallen99/9995893
  """

  def up() do
    :up
  end

  def down() do
    :down
  end

  def left() do
    :left
  end

  def right() do
    :right
  end

  def opsite_action(action) do
    case action do
      :up -> :down
      :down -> :up
      :left -> :right
      :right -> :left
    end
  end
end
