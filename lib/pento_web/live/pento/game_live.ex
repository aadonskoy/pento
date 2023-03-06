defmodule PentoWeb.Pento.GameLive do
  use PentoWeb, :live_view
  alias PentoWeb.Pento.Palette

  def mount(_params, _session, socket), do: {:ok, socket}
  def render(assigns) do
    ~H"""
    <section class="container">
      <h1>Welcome to Pento!</h1>
      <Palette.draw
        shape_names={ [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t] }
        fill="orange"
        name="p"
      />
    </section>
    """
  end
end
