defmodule WebWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use Phoenix.Controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> put_view(WebWeb.ErrorView)
    |> render("403.html")
  end

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_view(WebWeb.ErrorView)
    |> render("400.html")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(WebWeb.ErrorView)
    |> render("404.html")
  end

  def call(conn, _error) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(WebWeb.ErrorView)
    |> render("500.html")
  end
end
