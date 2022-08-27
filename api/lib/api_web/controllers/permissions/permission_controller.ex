defmodule ApiWeb.Users.PermissionController do
  use ApiWeb, :controller

  alias Api.Permissions
  alias Api.Users.Permission

  action_fallback ApiWeb.FallbackController

  def index(conn, params) do
    with {:ok, permissions} <- all_permissions(params) do
      render(conn, "index.json", permissions: permissions)
    end
  end

  defp all_permissions(params, preload \\ []) do
    case Permissions.all_permissions(params, preload) do
      {:ok, permissions} -> {:ok, permissions}
      {:error, error} -> {:error, error}
    end
  end
end
