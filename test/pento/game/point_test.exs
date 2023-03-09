defmodule Pento.Game.PointTest do
  use ExUnit.Case
  alias Pento.Game.Point

  describe "new" do
    test "return point" do
      assert Point.new(2, 5) == {2, 5}
    end
  end

  describe "operations on point" do
    setup do
      point = Point.new(2, 5)
      %{point: point}
    end

    test "operations", %{point: point} do
      point
      |> Point.move({1, -1})
      |> assert_point({3, 4})
      |> Point.transpose()
      |> assert_point({4, 3})
      |> Point.flip()
      |> assert_point({4, 3})
      |> Point.reflect()
      |> assert_point({2, 3})
      |> Point.rotate(0)
      |> assert_point({2, 3})
      |> Point.rotate(90)
      |> assert_point({3, 4})
      |> Point.rotate(180)
      |> assert_point({3, 2})
      |> Point.rotate(270)
      |> assert_point({4, 3})
      |> Point.center()
      |> assert_point({1, 0})
      |> Point.maybe_reflect(false)
      |> assert_point({1, 0})
      |> Point.maybe_reflect(true)
      |> assert_point({5, 0})
    end

    test "prepare operation", %{point: point} do
      point
      |> Point.prepare(180, true, {3, -2})
      |> assert_point({2, -4})
      |> Point.prepare(90, false, {3, -2})
      |> assert_point({-4, -1})
    end
  end

  defp assert_point(point, point_to) do
    assert point == point_to
    point
  end
end
