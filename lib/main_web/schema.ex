defmodule MainWeb.Schema do
  use Absinthe.Schema
  import_types(MainWeb.Schema.User)

  alias MainWeb.Resolvers

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve(&Resolvers.list_users/3)
    end
  end
end
