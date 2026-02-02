defmodule Pento.Game.Point do
  def new(x, y) when is_integer(x) and is_integer(y) do
    {x, y}
  end

  def move({x, y}, {change_x, change_y}) do
    {x + change_x, y + change_y}
  end

  def transpose({x, y}) do
    {y, x}
  end

  def flip({x, y}) do
    {x, 6 - y}
  end

  def reflect({x, y}) do
    {6 - x, y}
  end

  def rotate(point, 0) do
    point
  end

  def rotate(point, 90) do
    point
    |> reflect
    |> transpose
  end

  def rotate(point, 180) do
    point
    |> reflect
    |> flip
  end

  def rotate(point, 270) do
    point
    |> flip
    |> transpose
  end

  def center(point) do
    move(point, {-3, -3})
  end

  def prepare(point, rotation, reflected, location) do
    point
    |> rotate(rotation)
    |> maybe_reflect(reflected)
    |> move(location)
    |> center
  end

  def maybe_reflect(point, true), do: reflect(point)
  def maybe_reflect(point, false), do: point
end
