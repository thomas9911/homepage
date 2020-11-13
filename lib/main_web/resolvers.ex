defmodule MainWeb.Resolvers do
  require Main.Validation
  import Main.Validation

  def not_logged_in_error do
    {:error, "not logged in"}
  end

  def list_users(_parent, _args, _resolution) do
    {:ok,
     [
       %{
         "id" => "762345",
         "name" => "hi"
       },
       %{
         "id" => "23423",
         "name" => "hallo"
       },
       %{
         "id" => "147145",
         "name" => "bye"
       }
     ]}
  end

  def create_user(_, %{name: name, password: password}, %{context: %{logged_in?: true}}) do
    Main.new_user(name, password)
  end

  def create_user(_, _, _) do
    not_logged_in_error()
  end

  def create_post(_, data, %{context: %{user_id: user_id, logged_in?: true}}) do
    Main.new_post(user_id, data)
  end

  def create_post(_, _, _) do
    not_logged_in_error()
  end

  def delete_post(_, %{id: post_id}, %{context: %{user_id: _user_id, logged_in?: true}}) do
    Main.delete_post(post_id)
  end

  def delete_post(_, _, _) do
    not_logged_in_error()
  end

  def list_posts(_, args, _) do
    args
    |> validate_list_arguments()
    |> Main.list_posts()
  end

  def get_post(_, %{id: post_id}, _) when is_uuid(post_id) do
    Main.get_post(post_id)
  end

  def get_post(_, _, _) do
    {:error, "Invalid post id"}
  end

  def login(_, %{name: name, password: password}, _) do
    Main.login(name, password)
  end

  defp validate_list_arguments(args) do
    limit = args |> Map.get(:limit, 50) |> max(1) |> min(200)
    skip = args |> Map.get(:skip, 0) |> max(0)

    [skip: skip, limit: limit]
  end
end
