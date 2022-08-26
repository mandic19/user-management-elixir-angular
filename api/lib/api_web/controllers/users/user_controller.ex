defmodule ApiWeb.Users.UserController do
  use ApiWeb, :controller

  alias Api.Users
  alias Api.Users.User

  action_fallback ApiWeb.FallbackController

  plug(Loaders, :user when action in [:show, :update, :delete])

  def index(conn, params) do
    with {:ok, %Api.Paginator{
      entries: users,
      page_number: page_number,
      page_size: page_size,
      total_pages: total_pages
    }} <- all_users(params, [:permissions]) do
      render(conn, "index.json",
        users: users,
        page_number: page_number,
        page_size: page_size,
        total_pages: total_pages
      )
    end
  end

  defp all_users(params, preload \\ []) do
    case Users.all_users(params, preload) do
      {:ok, users} -> {:ok, users}
      {:error, error} -> {:error, error}
    end
  end

  def create(conn, params) do
      with {:ok, %User{} = user} <- Users.create_user(params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)
      end
  end

  def show(%{assigns: %{user: user}} = conn, _params),
    do: render(conn, "show.json", user: user)

  def update(%{assigns: %{user: user}} = conn, params) do
    with {:ok, %User{} = user} <- Users.update_user(user, params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(%{assigns: %{user: user}} = conn, params) do
    case Users.delete_user(user, params) do
      {:ok, %User{}} -> send_resp(conn, :no_content, "")
      {:error, error} -> {:error, error}
    end
  end
end
