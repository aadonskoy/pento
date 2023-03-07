defmodule PentoWeb.Pento.ControlPanel do
  use Phoenix.Component

  alias PentoWeb.Pento.Triangle

  def draw(assigns) do
    ~H"""
    <svg viewBox={@viewBox}>
      <defs>
        <polygon id="triangle" points="6.25 1.875, 12.5 12.5, 0 12.5" />
      </defs>
      <slot/>
        <Triangle.draw x="100" y="0" rotate="0" fill="#AAA" />
        <Triangle.draw x="94" y="-6" rotate="90" fill="#AAA" />
        <Triangle.draw x="88" y="0" rotate="180" fill="#AAA" />
        <Triangle.draw x="94" y="6" rotate="270" fill="#AAA" />
    </svg>
    """
  end
end
