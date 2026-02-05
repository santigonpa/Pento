defmodule Pento.Game.Board do
  alias Pento.Game.{Pentomino, Shape}

  defstruct active_pento: nil,
            completed_pentos: [],
            palette: [],
            points: []

  def puzzles() do
    ~w[tiny small ball donut default wide widest medium skewed_rectangle]a
  end

  def new(palette, points, hole \\ []) do
    %__MODULE__{palette: palette(palette), points: points -- hole}
  end

  def new(:tiny), do: new(:small, rect(5, 3))
  def new(:small), do: new(:medium, rect(7, 5))
  def new(:donut), do: new(:all, rect(8, 8), for(x <- 4..5, y <- 4..5, do: {x, y}))
  def new(:ball), do: new(:all, rect(8, 8), for(x <- [1, 8], y <- [1, 8], do: {x, y}))
  def new(:widest), do: new(:all, rect(20, 3))
  def new(:wide), do: new(:all, rect(15, 4))
  def new(:medium), do: new(:all, rect(12, 5))
  def new(:default), do: new(:all, rect(10, 6))
  def new(:skewed_rectangle), do: new(:all, skewed_rect(12, 5))

  defp rect(x, y) do
    for x <- 1..x, y <- 1..y, do: {x, y}
  end

  defp skewed_rect(w, h) do
    for i <- 1..w, j <- 1..h, do: {i + (h - j), j}
  end

  defp palette(:all), do: [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  defp palette(:medium), do: [:t, :y, :l, :p, :n, :v, :u]
  defp palette(:small), do: [:u, :v, :p]

  def to_shape(board) do
    Shape.__struct__(color: :purple, name: :board, points: board.points)
  end

  def to_shapes(board) do
    board_shape = to_shape(board)

    pento_shapes =
      [board.active_pento | board.completed_pentos]
      |> Enum.reverse()
      |> Enum.filter(& &1)
      |> Enum.map(&Pentomino.to_shape/1)

    [board_shape | pento_shapes]
  end

  def active?(board, shape_name) when is_binary(shape_name) do
    active?(board, String.to_existing_atom(shape_name))
  end

  def active?(%{active_pento: %{name: shape_name}}, shape_name), do: true
  def active?(_board, _shape_name), do: false

  def pick(board, :board) do
    board
  end

  def pick(%{active_pento: pento} = board, sname) when not is_nil(pento) do
    if pento.name == sname do
      %{board | active_pento: nil}
    else
      board
    end
  end

  def pick(board, shape_name) do
    active =
      board.completed_pentos
      |> Enum.find(&(&1.name == shape_name))
      |> Kernel.||(new_pento(board, shape_name))

    completed = Enum.filter(board.completed_pentos, &(&1.name != shape_name))

    %{board | active_pento: active, completed_pentos: completed}
  end

  defp new_pento(board, shape_name) do
    Pentomino.new(name: shape_name, location: midpoints(board))
  end

  defp midpoints(board) do
    {xs, ys} = Enum.unzip(board.points)
    {midpoint(xs), midpoint(ys)}
  end

  defp midpoint(i) do
    round(Enum.max(i) / 2)
  end

  def drop(%{active_pento: nil} = board), do: board

  def drop(%{active_pento: pento} = board) do
    board
    |> Map.put(:active_pento, nil)
    |> Map.put(:completed_pentos, [pento | board.completed_pentos])
  end

  def legal_drop?(%{active_pento: pento}) when is_nil(pento), do: false

  def legal_drop?(%{active_pento: pento, points: board_points} = board) do
    # create a list of all of the points that make up the active pento
    points_on_board =
      Pentomino.to_shape(pento).points
      # check to see if all of the pentomino’s points are contained in the board’s list of points
      |> Enum.all?(fn point -> point in board_points end)

    no_overlapping_pentos =
      !Enum.any?(board.completed_pentos, &Pentomino.overlapping?(pento, &1))

    points_on_board and no_overlapping_pentos
  end

  def legal_move?(%{active_pento: pento, points: points} = _board) do
    pento.location in points
  end

  def finished?(%{points: points, completed_pentos: pentos}) do
    completed_points =
      pentos
      |> Enum.map(&Pentomino.to_shape/1)
      |> Enum.flat_map(& &1.points)

      points -- completed_points == []
  end

  def calculate_score(%{completed_pentos: pentos}) do
    Enum.count(pentos) * 500
  end
end
