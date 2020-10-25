defmodule MainWeb.Resolvers do
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
    |> convert_to_atoms()
  end

  def create_user(_, %{name: name, password: password}, %{context: %{logged_in?: true}}) do
    Main.new_user(name, password) |> convert_to_atoms()
  end

  def create_user(_, _, _) do
    not_logged_in_error()
  end

  def create_post(_, data, %{context: %{user_id: user_id, logged_in?: true}}) do
    Main.new_post(user_id, data) |> convert_to_atoms()
  end

  def create_post(_, _, _) do
    not_logged_in_error()
  end

  def list_posts(_, _, _) do
    Main.list_posts() |> convert_to_atoms()
  end

  def login(_, %{name: name, password: password}, _) do
    Main.login(name, password) |> convert_to_atoms()
  end

  def convert_to_atoms({:ok, item}) do
    {:ok, convert_to_atoms(item)}
  end

  def convert_to_atoms({:error, _} = item), do: item

  def convert_to_atoms(list) when is_list(list) do
    Enum.map(list, &convert_to_atoms/1)
  end

  def convert_to_atoms(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {safe_atom_to_string(k), convert_to_atoms(v)} end)
  end

  def convert_to_atoms(any), do: any

  defp safe_atom_to_string(str) do
    String.to_existing_atom(str)
  rescue
    ArgumentError -> str
  end
end
