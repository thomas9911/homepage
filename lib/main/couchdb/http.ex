defmodule Main.CouchDB.Http do
  use Tesla

  alias Main.CouchDB.Context

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

  def create_database(database) do
    case validate_input(database) do
      {:ok, database} -> put("/:database", %{}, opts: [path_params: [database: database]])
      e -> e
    end
  end

  def delete_database(database) do
    case validate_input(database) do
      {:ok, database} -> delete("/:database", opts: [path_params: [database: database]])
      e -> e
    end
  end

  @doc """
  Create a new document in the given database
  """
  def post_data(database, data) when is_map(data) do
    with {:ok, database} <- validate_input(database),
         {:ok, env} <-
           post("/:database", put_id(data), opts: [path_params: [database: database]]),
         {:ok, %{id: id, rev: rev}} <- extract_id_and_rev(env),
         {:ok, ctx} <- get_data(database, id, rev) do
      {:ok, ctx}
    else
      {:error, %Tesla.Env{body: body}} -> {:error, body}
      {:error, error} -> {:error, error}
    end
  end

  def get_data(database, id, rev \\ nil) do
    req_opts = [
      opts: [path_params: [database: database, id: id]]
    ]

    req_opts =
      unless is_nil(rev) do
        Keyword.put(req_opts, :query, rev: rev)
      else
        req_opts
      end

    with {:ok, _database} <- validate_input(database),
         {:ok, _id} <- validate_input(id),
         {:ok, env} <- get("/:database/:id", req_opts),
         {:ok, data} <- extract_body(env) do
      {:ok, %Context{data: data, id: id, rev: rev}}
    else
      {:error, %Tesla.Env{body: body}} -> {:error, body}
      {:error, error} -> {:error, error}
    end
  end

  def get_count(database, design, view, key) do
    case get("/:database/_design/:design/_view/:view/",
           query: [group: true, key: "\"#{key}\""],
           opts: [path_params: [database: database, design: design, view: view]]
         ) do
      {:ok, %Tesla.Env{body: %{"rows" => [%{"key" => ^key, "value" => count}]}}} -> {:ok, count}
      {_, env} -> {:error, env}
    end
  end

  def delete_item(database, id, rev) do
    delete("/:database/:id", query: [rev: rev], opts: [path_params: [database: database, id: id]])
  end

  def search(database, filter, limit \\ 25) do
    case post("/:database/_find", %{selector: filter, limit: limit},
           opts: [path_params: [database: database]]
         ) do
      {:ok, env} -> extract_search(env)
      e -> e
    end
  end

  # helpers

  def extract_id_and_rev(%Tesla.Env{body: %{"ok" => true, "id" => id, "rev" => rev}}) do
    {:ok, %{id: id, rev: rev}}
  end

  def extract_id_and_rev(%Tesla.Env{} = env) do
    {:error, env}
  end

  def extract_body(%Tesla.Env{body: %{"_id" => id} = body, status: status})
      when status in 200..299 do
    {:ok, Map.put(body, "id", id)}
  end

  def extract_body(%Tesla.Env{} = env) do
    {:error, env}
  end

  def extract_search(%Tesla.Env{body: %{"docs" => docs}, status: status})
      when status in 200..299 do
    {:ok, Enum.map(docs, &map_ids/1)}
  end

  def extract_search(%Tesla.Env{} = env) do
    {:error, env}
  end

  defp map_ids(%{"_id" => id} = obj) do
    Map.put(obj, "id", id)
  end

  defp map_ids(obj), do: obj

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

# "/users/_design/users/_view/users/?group=true&key=XD"
