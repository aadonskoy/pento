defmodule PentoWeb.Pento.Score do
  @moduledoc false

  use Phoenix.Component

  def draw(assigns) do
    ~H"""
      <div>
        <h2>Your score <%= @score %></h2>
      </div>
    """
  end
end
