defmodule WebWeb.UserController do
  use WebWeb, :controller

  alias Web.API.Users
  alias WebWeb.Schemas.User

  action_fallback WebWeb.FallbackController

  plug(Loaders, :user when action in [:show, :delete])


  def index(conn, params) do
    with {:ok, users} <- Users.all_users(params) do
      render(conn, "index.html", users: users)
    end
  end
end
