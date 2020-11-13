defmodule MainWeb.Middlewares.MapToError do
  @moduledoc """
  Middleware to couchdb error map to string
  """

  @behaviour Absinthe.Middleware
  def call(%{errors: errors} = resolution, _) do
    %{resolution | errors: Enum.map(errors, &format_error/1)}
  end

  defp format_error(%{"error" => error}) do
    Recase.to_sentence(error)
  end

  defp format_error(value), do: value
end
