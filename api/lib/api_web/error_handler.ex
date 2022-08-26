defmodule ApiWeb.ErrorHandler do
  import Plug.Conn
  use Phoenix.Controller
  alias ApiWeb.ErrorView

  def resource_not_found(conn, _resource) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render(:"404")
    |> halt()
  end
end
