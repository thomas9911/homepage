defmodule MainWeb.Schema.General do
  use Absinthe.Schema.Notation

  object :id_item do
    field :id, :id
  end
end
