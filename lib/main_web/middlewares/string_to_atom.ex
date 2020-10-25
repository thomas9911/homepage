defmodule MainWeb.Middlewares.StringToAtom do
  @moduledoc """
  Middleware to convert map to atom maps that absinthe can handle
  """

  @behaviour Absinthe.Middleware
  def call(%{value: value} = resolution, _) do
    %{resolution | value: value_to_map(value)}
  end

  def value_to_map(map_or_list) when is_map(map_or_list) or is_list(map_or_list) do
    convert_to_atoms(map_or_list)
  end

  def value_to_map(value), do: value

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

  defp safe_atom_to_string(atom) when is_atom(atom), do: atom

  defp safe_atom_to_string(str) do
    String.to_existing_atom(str)
  rescue
    ArgumentError -> str
  end
end
