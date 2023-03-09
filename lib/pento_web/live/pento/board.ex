defmodule PentoWeb.Pento.Board do
  @moduledoc false

  use PentoWeb, :live_component

  alias PentoWeb.Pento.{Canvas, Palette, Shape}
  alias Pento.Game
  import PentoWeb.Pento.Colors

  def render(assigns) do
    ~H"""
    <div id={@id} phx-window-keydown="key" phx-target={@myself}>
      <PentoWeb.Pento.Score.draw score={@score} />
      <Canvas.draw viewBox="0 0 200 70">
        <%= for shape <- @shapes do %>
          <Shape.draw
            points={shape.points}
            fill={color(shape.color, Game.active?(@board, shape.name))}
            name={shape.name}
          />
        <% end %>
      </Canvas.draw>
      <hr/>
      <Palette.draw
        shape_names={@board.palette}
        id="palette"
      />
    </div>
    """
  end

  def update(%{puzzle: puzzle, id: id}, socket) do
    {:ok,
     socket
     |> assign_params(id, puzzle)
     |> assign_board()
     |> assign_shapes()
     |> assign_score()}
  end

  def handle_event("pick", %{"name" => name}, socket) do
    {
      :noreply,
      socket
      |> pick(name)
      |> assign_shapes
      |> assign_score
    }
  end

  def handle_event("key", %{"key" => key}, socket) do
    {
      :noreply,
      socket
      |> do_key(key)
      |> assign_shapes
      |> assign_score
    }
  end

  def assign_params(socket, id, puzzle) do
    assign(socket, id: id, puzzle: puzzle)
  end

  def assign_board(%{assigns: %{puzzle: puzzle}} = socket) do
    board =
      puzzle
      |> String.to_existing_atom()
      |> Game.new()

    assign(socket, board: board)
  end

  def assign_shapes(%{assigns: %{board: board}} = socket) do
    shapes = Game.to_shapes(board)
    assign(socket, shapes: shapes)
  end

  def assign_score(%{assigns: %{board: %{score: score}}} = socket) do
    assign(socket, score: score)
  end

  def do_key(socket, " "), do: drop(socket)
  def do_key(socket, "Space"), do: drop(socket)
  def do_key(socket, "ArrowLeft"), do: move(socket, :left)
  def do_key(socket, "ArrowRight"), do: move(socket, :right)
  def do_key(socket, "ArrowUp"), do: move(socket, :up)
  def do_key(socket, "ArrowDown"), do: move(socket, :down)
  def do_key(socket, "Enter"), do: move(socket, :flip)
  def do_key(socket, "Shift"), do: move(socket, :rotate)
  def do_key(socket, _), do: socket

  def move(socket, move) do
    case Game.maybe_move(socket.assigns.board, move) do
      {:error, message} ->
        put_flash(socket, :info, message)

      {:ok, board} ->
        socket |> assign(board: board) |> assign_shapes
    end
  end

  def drop(socket) do
    case Game.maybe_drop(socket.assigns.board) do
      {:error, message} ->
        put_flash(socket, :info, message)

      {:ok, board} ->
        socket |> assign(board: board) |> assign_shapes
    end
  end

  defp pick(socket, name) do
    shape_name = String.to_existing_atom(name)
    update(socket, :board, &Game.pick(&1, shape_name))
  end
end
