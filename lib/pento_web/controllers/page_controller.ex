defmodule PentoWeb.PageController do
  use PentoWeb, :controller

  def index(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: Routes.wrong_path(conn, :index))
    end
    render(conn, "index.html")
  end
end
