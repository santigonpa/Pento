defmodule Pento.Game.Pentomino do
  alias Pento.Game.Point
  alias Pento.Game.Shape

  @names [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  @default_location {8, 8}
  defstruct name: :i,
            rotation: 0,
            reflected: false,
            location: @default_location

  def new(fields \\ %{}) do
    __struct__(fields)
  end

  def rotate(%{rotation: degrees} = p, direction \\ :clockwise) do
    case direction do
      :clockwise -> %{p | rotation: rem(degrees + 90, 360)}
      :counterclockwise -> %{p | rotation: rem(degrees + 270, 360)}
    end
  end

  def up(p) do
    %{p | location: Point.move(p.location, {0, -1})}
  end

  def down(p) do
    %{p | location: Point.move(p.location, {0, 1})}
  end

  def left(p) do
    %{p | location: Point.move(p.location, {-1, 0})}
  end

  def right(p) do
    %{p | location: Point.move(p.location, {1, 0})}
  end

  def to_shape(pento) do
    Shape.new(pento.name, pento.rotation, pento.reflected, pento.location)
  end
end
