defmodule Api.Users.Resolvers.UserResolvers do
  use Api, :resolver

  alias Api.Users.Mutations.UserMutations, as: UM
  alias Api.Users.Queries.UserQueries, as: UQ
  alias Api.Users.User

  def all_users(params \\ %{}, preload \\ []) do
    with {:ok, params} <- UQ.prepare_query(params) do
      results =
        params
        |> UQ.query_all_users(preload)
        |> Api.Paginator.new(params)

      {:ok, results}
    end
  end

  def find_user(params, preload \\ [])

  def find_user(params, preload) when map_size(params) > 0 do
    with {:ok, params} <- UQ.prepare_query(params) do
      query = UQ.query_all_users(params, preload)

      case Repo.one(query) do
        nil -> {:error, :not_found}
        user -> {:ok, user}
      end
    end
  end

  def find_user(_params, _preload), do: {:error, :invalid_params}

  def create_user(params \\ %{}) do
    params
    |> UM.create_user_changeset()
    |> Repo.insert()
    |> format_results([:permissions])
  end

  def create_user!(params \\ %{}) do
    params
    |> UM.create_user_changeset()
    |> Repo.insert()
    |> format_results!([:permissions])
  end

  def update_user(%User{} = user, params \\ %{}) do
    user
    |> UM.update_user_changeset(params)
    |> Repo.update()
    |> format_results([:permissions])
  end

  def update_user!(%User{} = user, params \\ %{}) do
    user
    |> UM.update_user_changeset(params)
    |> Repo.update()
    |> format_results!([:permissions])
  end

  def delete_user(%User{} = user, params \\ %{}) do
    user
    |> UM.delete_user_changeset(params)
    |> Repo.update()
    |> format_results()
  end

  def delete_user!(%User{} = user, params \\ %{}) do
    user
    |> UM.delete_user_changeset(params)
    |> Repo.update()
    |> format_results!()
  end

  def update_permissions(%User{} = user, params \\ %{}) do
    user
    |> UM.update_permissions_multi(params)
    |> Repo.transaction()

    params = %{"id" => user.id}

    params
    |> find_user([:permissions])
  end

  defp format_results(result, preload \\ [])

  defp format_results({:ok, %User{} = user}, preload),
    do: {:ok, Repo.preload(user, preload)}

  defp format_results({:ok, %{permission: %User{} = user}}, preload),
    do: {:ok, Repo.preload(user, preload)}

  defp format_results(
         {:error, changeset},
         _preload
       ),
       do: {:error, changeset}


  defp format_results!(result, preload \\ [])

  defp format_results!({:ok, %User{} = user}, preload),
    do: Repo.preload(user, preload)

  defp format_results!(
         {:error, changeset},
         _preload
       ),
       do: raise(changeset)
end
