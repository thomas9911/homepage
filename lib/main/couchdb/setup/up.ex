defmodule Main.CouchDB.Setup.Up do
  @moduledoc """
  Contains code to setup the Couchdb database
  """
  import Main.CouchDB.Setup

  alias Main.CouchDB.Http

  @user_url "users"
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
  @post_design_url "/posts/_design/posts"
  @post_design %{
    _id: "_design/posts",
    views: %{
      posts: %{
        map:
          "function (doc) {\n  emit([doc.updated_at || \"z\", doc.created_at || \"z\"], null);\n}"
      }
    },
    language: "javascript"
  }

  @data_tables Main.CouchDB.Setup.__info__(:attributes)[:data_tables]

  def setup do
    create_user_database()
    create_user_design()
    create_admin_user()
    create_data_tables()
    create_post_design()

    :ok
  end

  def create_user_database do
    # print("create user database")
    # print_success(Http.create_database(@user_url))
    create_table(@user_url)
  end

  def create_user_design do
    print("create user design")
    print_success(Http.put(@user_design_url, @user_design))
  end

  def create_post_design do
    print("create post design")
    print_success(Http.put(@post_design_url, @post_design))
  end

  def create_admin_user do
    print("create admin user")
    %{user: user, password: password} = admin_user_config()
    print_success(Main.new_user(user, password))
  end

  def create_data_tables do
    Enum.each(@data_tables, &create_table/1)
  end

  defp create_table(table) do
    print("create #{table} database")
    print_success(Http.create_database(table))
  end

  defp admin_user_config() do
    cfg = Application.get_env(:main, Main.CouchDB.Setup)
    %{user: cfg[:admin_user], password: cfg[:admin_password]}
  end

  # # index
  # {
  #   "_id": "_design/700ae9eb4c3ddffe7f46e8b3140ee324aed53c0c",
  #   "_rev": "1-541457106de091fb5e9b2432e23e6112",
  #   "language": "query",
  #   "views": {
  #     "name-json-index": {
  #       "map": {
  #         "fields": {
  #           "name": "asc"
  #         },
  #         "partial_filter_selector": {}
  #       },
  #       "reduce": "_count",
  #       "options": {
  #         "def": {
  #           "fields": [
  #             "name"
  #           ]
  #         }
  #       }
  #     }
  #   }
  # }
end
