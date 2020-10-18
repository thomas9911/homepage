defmodule MainWeb.Schema.User do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
  end

  object :login do
    import_fields :user

    field :valid, :boolean
  end
end
