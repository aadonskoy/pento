defmodule PentoWeb.Pento.GameInstructions do
  @moduledoc false

  use Phoenix.Component

  def show(assigns) do
    ~H"""
    <p>Your goal is to place all figures onto the board</p>
    """
  end
end
