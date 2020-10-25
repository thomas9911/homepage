defmodule MainWeb.Schema.Post do
  use Absinthe.Schema.Notation

  object :post do
    field :id, :id
    field :title, :string
    field :content, :string
    field :created_at, :string
    field :updated_at, :string
    field :tags, list_of(:string)
  end
end
