defmodule MainWeb.Schema do
  use Absinthe.Schema

  import_types MainWeb.Schema.General
  import_types MainWeb.Schema.User
  import_types MainWeb.Schema.Post

  alias MainWeb.Middlewares.StringToAtom
  alias MainWeb.Resolvers

  def middleware(middleware, _field, _object) do
    middleware ++ [StringToAtom]
  end

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve &Resolvers.list_users/3
    end

    field :posts, list_of(non_null(:post)) do
      arg :limit, :integer
      arg :skip, :integer

      resolve &Resolvers.list_posts/3
    end
  end

  mutation do
    @desc "Create a user"
    field :create_user, type: :user do
      arg :name, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.create_user/3
    end

    @desc "Create a post"
    field :create_post, type: :post do
      arg :title, non_null(:string)
      arg :content, non_null(:string)

      resolve &Resolvers.create_post/3
    end

    @desc "Delete a post"
    field :delete_post, type: :id_item do
      arg :id, non_null(:id)

      resolve &Resolvers.delete_post/3
    end

    field :login, :login do
      arg :name, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.login/3
    end
  end
end
