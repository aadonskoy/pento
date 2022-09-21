defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}
  alias Pento.Accounts

  def render(assigns) do
    ~H"""
      <h1>Your score: <%= @score %></h1>
      <h2>
        <%= @message %>
        It's <%= @time %>
      </h2>
      <h2>
        <%= for n <- 1..10 do %>
          <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
        <% end %>
        <pre>
          <%= @current_user.email %>
          <%= @session_id %>
        </pre>
      </h2>
    """
  end

  def time() do
    DateTime.utc_now |> to_string()
  end

  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Guess a number.",
        time: time(),
        num: :rand.uniform(10),
        session_id: session["live_socket_id"]
      )
    }
  end

  def handle_event("guess", %{"number" => guess} = _data, socket) do
    socket = if Integer.to_string(socket.assigns.num) == guess do
      assign(
        socket,
        num: :rand.uniform(10),
        score: socket.assigns.score + 1,
        message: "Your guess: #{guess}. Correct! Guessed is changed."
      )
    else
      assign(
        socket,
        score: socket.assigns.score - 1,
        message: "Your guess: #{guess}. Wrong. Guess again."
      )
    end

    {
      :noreply,
      assign(socket, time: time())
    }
  end
end
