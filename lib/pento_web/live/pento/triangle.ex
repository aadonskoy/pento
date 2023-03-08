defmodule PentoWeb.Pento.Triangle do
  @moduledoc false

  use Phoenix.Component

  def draw(assigns) do
    ~H"""
    <use href="#triangle"
      x={@x}
      y={@y} transform={rotate(@rotate)}
      fill={@fill} />
    """
  end

  defp rotate(deg) do
    "rotate(#{deg}, 100, 20)"
  end
end
