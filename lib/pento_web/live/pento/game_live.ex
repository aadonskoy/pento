defmodule PentoWeb.Pento.GameLive do
  use PentoWeb, :live_view
  alias PentoWeb.Pento.{Board, GameInstructions}

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <section class="container">
      <h1>Welcome to Pento!</h1>
      <GameInstructions.show />
      <.live_component module={Board} puzzle={@puzzle} id="game" />
      <PentoWeb.Pento.ControlPanel.draw viewBox="0 0 200 40"/>
    </section>
    """
  end

  def mount(%{"puzzle" => puzzle}, _session, socket), do: {:ok, assign(socket, puzzle: puzzle)}
end
