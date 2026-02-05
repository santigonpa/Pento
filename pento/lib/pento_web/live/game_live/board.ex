defmodule PentoWeb.GameLive.Board do
  use PentoWeb, :live_component

  alias Pento.Game

  import PentoWeb.GameLive.{Colors, Component}

  def update(%{puzzle: puzzle, id: id}, socket) do
    {:ok,
     socket
     |> assign_params(id, puzzle)
     |> assign_board()
     |> assign_shapes()}
  end

  def assign_params(socket, id, puzzle) do
    assign(socket, id: id, puzzle: puzzle)
  end

  def assign_board(%{assigns: %{puzzle: puzzle}} = socket) do
    board =
      puzzle
      |> String.to_existing_atom()
      |> Game.Board.new()

    assign(socket, board: board)
  end

  def assign_shapes(%{assigns: %{board: board}} = socket) do
    shapes = Game.Board.to_shapes(board)

    assign(socket, shapes: shapes)
  end

  def handle_event("pick", %{"name" => name}, socket) do
    {:noreply, socket |> pick(name) |> assign_shapes}
  end

  def handle_event("key", %{"key" => key}, socket) do
    {:noreply, socket |> do_key(key) |> assign_shapes}
  end

  def do_key(socket, key) do
    case key do
      " " -> drop(socket)
      "ArrowLeft" -> move(socket, :left)
      "ArrowRight" -> move(socket, :right)
      "ArrowUp" -> move(socket, :up)
      "ArrowDown" -> move(socket, :down)
      "Shift" -> move(socket, :rotate)
      "Enter" -> move(socket, :flip)
      "Space" -> drop(socket)
      _ -> socket
    end
  end

  def move(socket, move) do
    case Game.maybe_move(socket.assigns.board, move) do
      {:error, message} ->
        IO.inspect("Move error: #{message}")

        socket
        |> put_flash(:info, message)

      {:ok, board} ->
        socket |> assign(board: board) |> assign_shapes
    end
  end

  defp drop(socket) do
    case Game.maybe_drop(socket.assigns.board) do
      {:error, message} ->
        IO.inspect("Move error: #{message}")

        socket
        |> put_flash(:info, "message")

      {:ok, board} ->
        socket |> assign(board: board) |> assign_shapes
    end
  end

  defp pick(socket, name) do
    shape_name = String.to_existing_atom(name)
    update(socket, :board, &Game.Board.pick(&1, shape_name))
  end

  def render(assigns) do
    ~H"""
    <div id={ @id } phx-window-keydown="key" phx-target={ @myself }>
      <.canvas view_box="0 0 200 140">
        <%= for shape <- @shapes do %>
          <.shape
            points={ shape.points }
            fill= { color(shape.color, Game.Board.active?(@board, shape.name), false) }
            name={ shape.name }
          />
        <% end %>
      </.canvas>
      <hr/>
      <.palette
        shape_names={@board.palette}
        completed_shape_names= {Enum.map(@board.completed_pentos, & &1.name)}
      />
      <hr/>
      <p>Control Panel</p>
      <.control_panel view_box="0 0 200 40">
        <.triangle x={100} y={9} rotate={0} fill="lightsteelblue" />
        <.triangle x={90} y={20} rotate={270} fill="lightsteelblue" />
        <.triangle x={110} y={20} rotate={90} fill="lightsteelblue" />
        <.triangle x={100} y={31} rotate={180} fill="lightsteelblue" />
      </.control_panel>
    </div>
    """
  end
end
