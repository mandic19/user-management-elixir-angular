defmodule Api.Users.Resolvers.PermissionResolvers do
  use Api, :resolver

  alias Api.Users.Queries.PermissionQueries, as: PQ
  alias Api.Users.Permission

  def all_permissions(params \\ %{}, preload \\ []) do
    with {:ok, params} <- PQ.prepare_query(params) do
      permissions =
        params
        |> PQ.query_all_permissions(preload)
        |> Repo.all()

      {:ok, permissions}
    end
  end
end
