defmodule Api.Users do
    alias Api.Users.Resolvers.UserResolvers, as: UR

    defdelegate all_users(params \\ %{}, preload \\ []), to: UR
    defdelegate find_user(params, preload \\ []), to: UR
    defdelegate create_user(params \\ %{}), to: UR
    defdelegate create_user!(params \\ %{}), to: UR
    defdelegate update_user(user, params \\ %{}), to: UR
    defdelegate update_user!(user, params \\ %{}), to: UR
    defdelegate delete_user(user, params \\ %{}), to: UR
    defdelegate delete_user!(user, params \\ %{}), to: UR
end
