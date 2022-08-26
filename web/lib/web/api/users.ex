defmodule Web.API.Users do
  alias Ecto.Changeset

  alias Web.Schemas.User

  @success_codes 200..399

  def all_users(params, headers \\ %{}) do
    url = "http://localhost:4001/api/users"

    with %{valid?: true} = changeset <- User.query_changeset(%User.Query{}, params),
         query =
           changeset
           |> Changeset.apply_changes()
           |> Map.from_struct(),

         {:ok, %{body: body, status: status}} when status in @success_codes <-
           HTTPoison.get(url, body: query) do
      {:ok, parse_response(body, headers)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  defp parse_response(body, headers) do
    accept = Map.get(headers, "accept")

    if accept && accept != "application/json" do
      body
    else
      Enum.map(body, &from_response/1)
    end
  end

  defp from_response(response),
    do: %User{} |> User.changeset(response) |> Changeset.apply_changes()
end
