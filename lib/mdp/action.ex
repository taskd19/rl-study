defmodule RlStudy.MDP.Action do
  @moduledoc """
  ref: https://gist.github.com/smpallen99/9995893
  """

  @doc """
      iex> RlStudy.MDP.Action.up()
      :up
  """
  @spec up :: :up
  def up() do
    :up
  end

  @spec down :: :down
  def down() do
    :down
  end

  @spec left :: :left
  def left() do
    :left
  end

  @spec right :: :right
  def right() do
    :right
  end

  @doc """
      iex> RlStudy.MDP.Action.opsite_action(:up)
      :down
      iex> RlStudy.MDP.Action.opsite_action(:down)
      :up
      iex> RlStudy.MDP.Action.opsite_action(:left)
      :right
      iex> RlStudy.MDP.Action.opsite_action(:right)
      :left
  """
  @spec opsite_action(:down | :left | :right | :up) :: :down | :left | :right | :up
  def opsite_action(action) do
    case action do
      :up -> :down
      :down -> :up
      :left -> :right
      :right -> :left
    end
  end
end
