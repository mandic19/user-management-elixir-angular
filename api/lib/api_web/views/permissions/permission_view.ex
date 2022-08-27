defmodule ApiWeb.Users.PermissionView do
  use ApiWeb, :view

  def render("index.json", %{permissions: permissions}) do
    render_many(permissions, __MODULE__, "permission.json")
  end

  def render("show.json", %{permission: permission}) do
    render_one(permission, __MODULE__, "permission.json")
  end

  def render("permission.json", %{permission: permission}) do
    permission
  end
end
