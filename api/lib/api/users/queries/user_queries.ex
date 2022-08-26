defmodule Api.Users.Queries.UserQueries do
  use Api, :query

  alias Api.Users.User

  def query_all_users(params \\ %{}, preload \\ []) do
    query = from(
      u in User,
      where: is_nil(u.deleted_at)
    )

    query = query_by(query, params)
    sort_by(query, params, preload)
  end

  defp query_by(query, %{"id" => id} = params) do
    query = from(q in query, where: q.id == ^id)

    query_by(query, Map.delete(params, "id"))
  end

  defp query_by(query, %{"first_name" => first_name} = params) do
    query = from(q in query, where: ilike(q.first_name, ^"%#{first_name}%"))

    query_by(query, Map.delete(params, "first_name"))
  end

  defp query_by(query, %{"last_name" => last_name} = params) do
    query = from(q in query, where: ilike(q.last_name, ^"%#{last_name}%"))

    query_by(query, Map.delete(params, "last_name"))
  end

  defp query_by(query, %{"email" => email} = params) do
    query = from(q in query, where: ilike(q.email, ^"%#{email}%"))

    query_by(query, Map.delete(params, "email"))
  end

  defp query_by(query, %{"username" => username} = params) do
    query = from(q in query, where: ilike(q.username, ^"%#{username}%"))

    query_by(query, Map.delete(params, "username"))
  end

  defp query_by(query, %{"status" => status} = params) do
    query = from(q in query, where: q.status == ^status)

    query_by(query, Map.delete(params, "status"))
  end

  defp query_by(query, %{"q" => search_query} = params) do
    query =
      from(q in query,
        where:
          fragment(
            "concat_ws(' ', ?, ?, ?, ?, ?) ILIKE ?",
            q.first_name,
            q.last_name,
            q.email,
            q.username,
            q.status,
            ^"%#{search_query}%"
          )
      )

    query_by(query, Map.delete(params, "q"))
  end

  defp query_by(query, _params), do: query

  defp sort_by(query, %{"sort" => "first_name"}, preload),
    do: from(q in subquery(query), order_by: [asc: q.first_name], preload: ^preload)

  defp sort_by(query, %{"sort" => "-first_name"}, preload),
    do: from(q in subquery(query), order_by: [desc: q.first_name], preload: ^preload)

  defp sort_by(query, %{"sort" => "last_name"}, preload),
    do: from(q in subquery(query), order_by: [asc: q.last_name], preload: ^preload)

  defp sort_by(query, %{"sort" => "-last_name"}, preload),
    do: from(q in subquery(query), order_by: [desc: q.last_name], preload: ^preload)

  defp sort_by(query, %{"sort" => "email"}, preload),
    do: from(q in subquery(query), order_by: [asc: q.email], preload: ^preload)

  defp sort_by(query, %{"sort" => "-email"}, preload),
    do: from(q in subquery(query), order_by: [desc: q.email], preload: ^preload)

  defp sort_by(query, %{"sort" => "username"}, preload),
    do: from(q in subquery(query), order_by: [asc: q.username], preload: ^preload)

  defp sort_by(query, %{"sort" => "-username"}, preload),
    do: from(q in subquery(query), order_by: [desc: q.username], preload: ^preload)

  defp sort_by(query, %{"sort" => "status"}, preload),
    do: from(q in subquery(query), order_by: [asc: q.status], preload: ^preload)

  defp sort_by(query, %{"sort" => "-status"}, preload),
    do: from(q in subquery(query), order_by: [desc: q.status], preload: ^preload)

  defp sort_by(query, _params, preload),
    do: from(q in subquery(query), order_by: [desc: q.inserted_at], preload: ^preload)

  def prepare_query(params), do: prepare_query(params, %{})

  defp prepare_query(params, acc), do: {:ok, Map.merge(acc, params)}
end
