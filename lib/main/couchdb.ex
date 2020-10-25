defmodule Main.CouchDB do
  alias Main.CouchDB.Http
  alias Main.CouchDB.Context

  @user_table "users"
  @user_design "users"
  @user_view "users"

  @post_table "posts"

  def create_user(name, password) do
    with {:ok, ctx} <- Http.post_data(@user_table, %{"name" => name, "password" => password}),
         {:ok, unique} <- check_user_uniqueness(name),
         :ok <- delete_exists(ctx, unique),
         {:ok, [data]} <- refetch_user(ctx.data, name, unique) do
      {:ok, data}
    else
      e ->
        e
    end
  end

  def get_user(id) do
    Http.get_data(@user_table, id)
  end

  def get_user_by_name(name) do
    refetch_user(%{}, name)
  end

  defp delete_exists(%Context{id: id, rev: rev}, false) do
    case delete_user(id, rev) do
      {:ok, _env} -> :ok
      e -> e
    end
  end

  defp delete_exists(_, true), do: :ok

  def delete_user(id, revision) do
    Http.delete_item(@user_table, id, revision)
  end

  def refetch_user(current_data, name, unique \\ false)

  def refetch_user(_current_data, name, false) do
    Http.search(@user_table, %{name: name}, 1)
  end

  def refetch_user(current_data, _name, true) do
    {:ok, [current_data]}
  end

  def check_user_uniqueness(name) do
    case Http.get_count(@user_table, @user_design, @user_view, name) do
      {:ok, 1} -> {:ok, true}
      {:ok, _} -> {:ok, false}
      e -> e
    end
  end

  # posts

  def create_post(user_id, data) do
    now = DateTime.utc_now() |> DateTime.to_iso8601()

    data =
      data
      |> Map.put(:user, user_id)
      |> Map.put_new(:updated_at, now)
      |> Map.put_new(:created_at, now)

    case Http.post_data(@post_table, data) do
      {:ok, ctx} -> {:ok, ctx.data}
      {:error, e} -> {:error, e}
    end
  end

  def list_posts() do
    case Http.list_data(@post_table) do
      {:ok, ctx} -> {:ok, ctx.data}
      e -> e
    end
  end
end

# Main.CouchDB.Http.get("/users/_design/users/_view/users/", query: [group: true, key: "\"XD\""])
