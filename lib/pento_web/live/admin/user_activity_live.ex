defmodule PentoWeb.Admin.UserActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence

  @impl true
  def render(assigns) do
    ~H"""
      <div class="user-activity-component">
        <h2>User Activity</h2>
        <p>Active users currently viewing games</p>
        <div>
          <%= for {product_name, users} <- @user_activity do %>
            <h3><%= product_name %></h3>
            <ul>
              <%= for user <- users do %>
                <li><%= user.email %></li>
              <% end %>
            </ul>
          <% end %>
        </div>
      </div>
    """
  end

  @impl true
  def update(_assigns, socket) do
    {:ok,
      socket
      |> assign_user_activity()}
  end

  def assign_user_activity(socket) do
    assign(socket, :user_activity, Presence.list_products_and_users())
  end
end
