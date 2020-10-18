defmodule Main.CouchDB.Setup do
  alias Main.CouchDB.Http

  @user_url "/users"
  @user_design_url "/users/_design/users"
  @user_design %{
    _id: "_design/users",
    views: %{
      users: %{
        reduce: "_count",
        map: "function (doc) {\n  emit(doc.name, 1);\n}"
      }
    },
    language: "javascript"
  }

  def setup do
    create_user_database()
    create_user_design()

    :ok
  end

  def create_user_database do
    Http.put(@user_url, %{})
  end

  def create_user_design do
    Http.put(@user_design_url, @user_design)
  end
end
