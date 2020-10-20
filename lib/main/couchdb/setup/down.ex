defmodule Main.CouchDB.Setup.Down do
  @moduledoc """
  Contains code to drop the Couchdb database
  """
  import Main.CouchDB.Setup

  alias Main.CouchDB.Http

  @user_url "users"

  def drop do
    drop_user_database()

    :ok
  end

  def drop_user_database do
    print("delete user database")
    print_success(Http.delete_database(@user_url))
  end
end
