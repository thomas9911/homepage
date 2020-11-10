defmodule MainWeb.PageControllerTest do
  use MainWeb.ConnCase

  # alias MainWeb.TestHelpers
  setup_all do
    with {:ok, [user]} <- Main.get_user_by_name("admin"),
         {:ok, token, _full_claims} <- Main.Guardian.encode_and_sign(user) do
      {:ok, %{token: token}}
    else
      {:ok, []} -> {:error, "admin user not found"}
      e -> e
    end
  end

  # test "GET /", %{conn: conn} do
  #   conn = get(conn, "/")
  #   assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  # end

  test "login with admin", %{conn: conn} do
    query = """
    mutation login($name: String!, $password: String!) {
      login(name: $name, password: $password) {
        id
        name
        valid
        jwt
      }
    }
    """

    conn = gql(conn, query, %{name: "admin", password: "password"})

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

  describe "createUser" do
    @query """
    mutation newUser($name: String!, $password: String!) {
      createUser(name: $name, password: $password) {
        id
        name
      }
    }
    """

    test "valid", %{conn: conn, token: token} do
      conn = gql(conn, @query, %{name: "admin", password: "password"}, token)

      assert {:ok,
              %{
                "data" => %{
                  "createUser" => %{
                    "name" => "admin"
                  }
                }
              }} = Jason.decode(conn.resp_body)
    end

    test "invalid", %{conn: conn} do
      conn = gql(conn, @query, %{name: "admin", password: "password"})

      assert {:ok,
              %{
                "errors" => [
                  %{
                    "message" => "not logged in"
                  }
                ]
              }} = Jason.decode(conn.resp_body)
    end
  end

  describe "posts" do
    @query """
    query listPosts{
      posts{
        title
        content
        updatedAt
      }
    }
    """

    @create_mutation """
    mutation createPost($title: String!, $content: String!){
      createPost(title: $title, content: $content){
        id
        content
        title
        createdAt
      }
    }
    """

    @delete_mutation """
    mutation deletePost($id: ID!){
      deletePost(id: $id){
        id
      }
    }
    """

    test "valid", %{conn: conn} do
      conn = gql(conn, @query)
      {:ok, %{"data" => %{"posts" => posts}}} = Jason.decode(conn.resp_body)

      assert [
               %{
                 "content" => "Just some text, nice!",
                 "title" => "Title1",
                 "updatedAt" => _
               },
               %{
                 "content" => "Just some other, nice!",
                 "title" => "Title2",
                 "updatedAt" => _
               },
               %{
                 "content" => "Just some more text, neat!",
                 "title" => "Title3",
                 "updatedAt" => _
               }
             ] = Enum.sort_by(posts, &Map.get(&1, "title"))
    end

    test "create post and delete it", %{conn: conn, token: token} do
      conn = gql(conn, @create_mutation, %{title: "Nice title", content: "Just some text"}, token)
      {:ok, %{"data" => %{"createPost" => post}}} = Jason.decode(conn.resp_body)

      assert %{
               "id" => id,
               "title" => "Nice title",
               "content" => "Just some text",
               "createdAt" => _
             } = post

      conn = recycle(conn)

      conn = gql(conn, @delete_mutation, %{id: id}, token)
      {:ok, %{"data" => %{"deletePost" => %{"id" => _}}}} = Jason.decode(conn.resp_body)
    end
  end
end
