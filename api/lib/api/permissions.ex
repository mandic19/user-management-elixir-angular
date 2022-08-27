defmodule Api.Permissions do
  alias Api.Users.Resolvers.PermissionResolvers, as: PR

  defdelegate all_permissions(params \\ %{}, preload \\ []), to: PR
end
