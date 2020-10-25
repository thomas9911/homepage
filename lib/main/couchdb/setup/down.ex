defmodule Main.CouchDB.Setup.Down do
  @moduledoc """
  Contains code to drop the Couchdb database
  """
  import Main.CouchDB.Setup

  alias Main.CouchDB.Http

  @user_url "users"
  @data_tables Main.CouchDB.Setup.__info__(:attributes)[:data_tables]

  def drop do
    drop_user_database()
    drop_data_tables()
    :ok
  end

  def drop_user_database do
    drop_table(@user_url)
  end

  def drop_data_tables do
    Enum.each(@data_tables, &drop_table/1)
  end

  defp drop_table(table) do
    print("delete #{table} database")
    print_success(Http.delete_database(table))
  end
end
