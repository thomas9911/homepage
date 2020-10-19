defmodule MainWeb.Context do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the connection
  """
  def build_context(conn) do
    claims = Guardian.Plug.current_claims(conn) || %{}

    user_id = Map.get(claims, "sub")

    %{
      logged_in?: Guardian.Plug.authenticated?(conn),
      user_id: user_id
    }
  end
end
