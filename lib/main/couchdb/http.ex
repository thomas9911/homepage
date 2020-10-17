defmodule Main.CouchDB.Http do
  use Tesla

  plug Tesla.Middleware.BaseUrl, couchdb_url()
  plug Tesla.Middleware.BasicAuth, username: username(), password: password()
  plug Tesla.Middleware.PathParams
  plug Tesla.Middleware.JSON

  @doc """
  Creates a new database
  """
  def get_database(database) do
    case validate_input(database) do
      {:ok, database} -> get("/:database", opts: [path_params: [database: database]])
      e -> e
    end
  end

  @doc """
  Create a new document in the given database
  """
  def post_data(database, data) when is_map(data) do
    case validate_input(database) do
      {:ok, database} ->
        post("/:database", put_id(data), opts: [path_params: [database: database]])

      e ->
        e
    end
  end

  # helpers

  defp validate_input(input) when is_binary(input) do
    with false <- String.contains?(input, "/") do
      {:ok, input}
    else
      true -> {:error, :contains_forward_slash}
    end
  end

  defp validate_input(_input), do: {:error, :non_binary_input}

  defp generate_id, do: UUID.uuid4(:hex)

  defp put_id(data) when is_map(data) do
    Map.put_new(data, "_id", generate_id())
  end

  # config stuff
  defp couchdb_url, do: app_config()[:url]
  defp username, do: app_config()[:user]
  defp password, do: app_config()[:password]

  defp app_config, do: Application.fetch_env!(:main, Main.CouchDB)
end
