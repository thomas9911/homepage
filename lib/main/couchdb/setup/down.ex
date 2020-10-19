defmodule Main.CouchDB.Setup.Down do
  @moduledoc """
  Contains code to drop the Couchdb database
  """

  alias Main.CouchDB.Http

  @user_url "users"

  def drop do
    drop_user_database()

    :ok
  end

  def drop_user_database do
    Http.delete_database(@user_url)
  end
end
