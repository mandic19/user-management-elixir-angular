defmodule ApiWeb.Loaders do
  use PolicyWonk.Load
  use PolicyWonk.Resource

  alias ApiWeb.Users.Loaders.UserLoaders
  alias ApiWeb.ErrorHandler


  def resource(conn, resource, params)
      when resource in [:user, :users],
      do: UserLoaders.resource(conn, resource, params)

  def resource(conn, _resource, _params), do: resource_error(conn, nil)

  def resource_error(conn, resource_id) do
    ErrorHandler.resource_not_found(conn, resource_id)
  end
end
