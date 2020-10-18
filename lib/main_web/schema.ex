defmodule MainWeb.Schema do
  use Absinthe.Schema
  import_types(MainWeb.Schema.User)

  alias MainWeb.Resolvers

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve &Resolvers.list_users/3
    end

    field :login, :login do
      arg :name, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.login/3
    end
  end

  mutation do
    @desc "Create a user"
    field :create_user, type: :user do
      arg :name, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.create_user/3
    end
  end
end
