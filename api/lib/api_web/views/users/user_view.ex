defmodule ApiWeb.Users.UserView do
  use ApiWeb, :view

  def render("index.json", %{
    users: users,
    page_number: page_number,
    page_size: page_size,
    total_pages: total_pages
  }) do
    %{
      results: render_many(users, __MODULE__, "user.json"),
      page_number: page_number,
      page_size: page_size,
      total_pages: total_pages
    }
  end

  def render("show.json", %{user: user}) do
    render_one(user, __MODULE__, "user.json")
  end

  def render("user.json", %{user: user}) do
    user
  end
end
