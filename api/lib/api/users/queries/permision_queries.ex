defmodule Api.Users.Queries.PermissionQueries do
  use Api, :query

  alias Api.Users.Permission

  def query_all_permissions(params \\ %{}, preload \\ []) do
    query = from(
      p in Permission,
      where: is_nil(p.deleted_at)
    )

    query = query_by(query, params)
  end

  defp query_by(query, %{"id" => id} = params) do
    query = from(q in query, where: q.id == ^id)

    query_by(query, Map.delete(params, "id"))
  end

  defp query_by(query, _params), do: query

  def prepare_query(params), do: prepare_query(params, %{})

  defp prepare_query(params, acc), do: {:ok, Map.merge(acc, params)}
end
