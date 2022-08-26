defmodule ApiWeb.Users.Loaders.UserLoaders do
  alias Api.Users

  def resource(_conn, :user, %{"id" => id}) do
    case Users.find_user(%{"id" => id}, [:permissions]) do
      {:ok, user} -> {:ok, :user, user}
      {:error, _message} -> {:error, :user}
    end
  end
end
