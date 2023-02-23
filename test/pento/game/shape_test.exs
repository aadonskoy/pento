defmodule Pento.Game.ShapeTest do
  use ExUnit.Case
  alias Pento.Game.Shape

  describe "shape" do
    test "create" do
      assert Shape.new(:x, 90, false, {3, 5}) ==
        %Shape{
          points: [{2, 5}, {3, 6}, {3, 5}, {3, 4}, {4, 5}],
          color: :blue,
          name: :x
        }
    end
  end
end
