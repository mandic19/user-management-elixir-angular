defmodule ApiWeb.Router do
  use ApiWeb, :router


  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ApiWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug
  end

  scope "/api" do
    pipe_through :api

    resources "/permissions", ApiWeb.Users.PermissionController, only: [:index]

    resources "/users", ApiWeb.Users.UserController

    put "/users/:id/permissions", ApiWeb.Users.UserController, :update_permissions
  end
end
