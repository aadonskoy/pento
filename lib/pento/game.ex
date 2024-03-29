defmodule Pento.Game do
  @moduledoc false

  alias Pento.Game.{Board, Pentomino}

  @messages %{
    out_of_bounds: "Out of bounds!",
    illegal_drop: "Oops! You can't drop out of bounds or an another piece."
  }

  defdelegate active?(board, shape_name), to: Board
  defdelegate new(puzzle_type), to: Board
  defdelegate to_shapes(board), to: Board
  defdelegate pick(pento, shape_name), to: Board

  def maybe_move(%{active_pento: p} = board, _m) when is_nil(p) do
    {:ok, board}
  end

  def maybe_move(board, move) do
    new_pento = move_fn(move).(board.active_pento)
    new_board = %{board | active_pento: new_pento}

    if Board.legal_move?(new_board) do
      {:ok, decrease_score(new_board)}
    else
      {:error, @messages.out_of_bounds}
    end
  end

  defp move_fn(move) do
    case move do
      :up -> &Pentomino.up/1
      :down -> &Pentomino.down/1
      :left -> &Pentomino.left/1
      :right -> &Pentomino.right/1
      :flip -> &Pentomino.flip/1
      :rotate -> &Pentomino.rotate/1
    end
  end

  def maybe_drop(board) do
    if Board.legal_drop?(board) do
      {:ok, Board.drop(board)}
    else
      {:error, @messages.illegal_drop}
    end
  end

  def decrease_score(%{score: score} = board) when score > 0 do
    new_score = score - 1
    %{board | score: new_score}
  end
end
