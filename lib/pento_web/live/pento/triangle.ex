defmodule PentoWeb.Pento.Triangle do
  use Phoenix.Component

  def draw(assigns) do
    ~H"""
    <use xlink:href="#triangle"
      x={@x}
      y={@y} transform={rotate(@rotate)}
      fill={@fill} />
    """
  end

  defp rotate(deg) do
    "rotate(#{deg}, 100, 20)"
  end
end
