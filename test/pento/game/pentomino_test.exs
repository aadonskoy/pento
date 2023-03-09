defmodule Pento.Game.PentominoTest do
  use ExUnit.Case
  alias Pento.Game.Pentomino

  describe "pentomino" do
    test "operations" do
      Pentomino.new()
      |> assert_pentomino(:i)
      |> Pentomino.rotate()
      |> assert_pentomino(:i, 90)
      |> Pentomino.rotate()
      |> assert_pentomino(:i, 180)
      |> Pentomino.rotate()
      |> assert_pentomino(:i, 270)
      |> Pentomino.rotate()
      |> assert_pentomino(:i, 0)
      |> Pentomino.flip()
      |> assert_pentomino(:i, 0, true)
      |> Pentomino.up()
      |> assert_pentomino(:i, 0, true, {8, 7})
    end
  end

  defp assert_pentomino(pentomino, name) do
    assert pentomino == %Pentomino{name: name, rotation: 0, reflected: false, location: {8, 8}}
    pentomino
  end

  defp assert_pentomino(pentomino, name, rotation) do
    assert pentomino == %Pentomino{
             name: name,
             rotation: rotation,
             reflected: false,
             location: {8, 8}
           }

    pentomino
  end

  defp assert_pentomino(pentomino, name, rotation, reflected) do
    assert pentomino == %Pentomino{
             name: name,
             rotation: rotation,
             reflected: reflected,
             location: {8, 8}
           }

    pentomino
  end

  defp assert_pentomino(pentomino, name, rotation, reflected, location) do
    assert pentomino == %Pentomino{
             name: name,
             rotation: rotation,
             reflected: reflected,
             location: location
           }

    pentomino
  end
end
