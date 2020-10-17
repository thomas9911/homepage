defmodule MainWeb.Resolvers do
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
     ]|> convert_to_atoms()}
  end

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
