defmodule RlStudy.MDP.Action do
  @moduledoc """
  ref: https://gist.github.com/smpallen99/9995893
  """
  @type t :: :down | :left | :right | :up

  @doc """
  # Examples
      iex> RlStudy.MDP.Action.up()
      :up
  """
  @spec up :: :up
  def up() do
    :up
  end

  @doc """
  # Examples
      iex> RlStudy.MDP.Action.down()
      :down
  """
  @spec down :: :down
  def down() do
    :down
  end

  @doc """
  # Examples
      iex> RlStudy.MDP.Action.left()
      :left
  """
  @spec left :: :left
  def left() do
    :left
  end

  @doc """
  # Examples
      iex> RlStudy.MDP.Action.right()
      :right
  """
  @spec right :: :right
  def right() do
    :right
  end

  @doc """
  # Examples
      iex> RlStudy.MDP.Action.opsite_action(:up)
      :down
      iex> RlStudy.MDP.Action.opsite_action(:down)
      :up
      iex> RlStudy.MDP.Action.opsite_action(:left)
      :right
      iex> RlStudy.MDP.Action.opsite_action(:right)
      :left
  """
  @spec opsite_action(RlStudy.MDP.Action.t()) :: RlStudy.MDP.Action.t()
  def opsite_action(action) do
    case action do
      :up -> :down
      :down -> :up
      :left -> :right
      :right -> :left
    end
  end
end
