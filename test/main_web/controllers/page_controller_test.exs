defmodule MainWeb.PageControllerTest do
  use MainWeb.ConnCase

  # alias MainWeb.TestHelpers

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  test "login with admin", %{conn: conn} do
    query = """
    query login($name: String!, $password: String!) {
      login(name: $name, password: $password) {
        id
        name
        valid
        jwt
      }
    }
    """

    conn = gql(conn, query, %{name: "admin", password: "password"})

    # IO.inspect(conn)

    assert {:ok,
            %{
              "data" => %{
                "login" => %{
                  "name" => "admin",
                  "valid" => true,
                  "jwt" => "ey" <> _
                }
              }
            }} = Jason.decode(conn.resp_body)
  end
end
