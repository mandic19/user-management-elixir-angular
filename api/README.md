# User management system

To start your App:

  * In a project root build and start docker containers with `docker-compose up`
  * Go to API root with `cd api`
  * Create and migrate your database with `mix ecto.setup`
  * Import initial data into database with `mix run priv/repo/seeds.exs`
  * Go back to project root with `cd ..`
  * Go to http://localhost:4000 and start working