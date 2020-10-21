defmodule MainWeb.PageController do
  use MainWeb, :controller

  # @priv_dir :code.priv_dir(:main) |> to_string()
  @priv_dir "./priv/static/"

  def index(conn, params) do
    # render(conn, "index.html")
    # send_file(conn, "index.html")
    # put_layout(conn, false)

    # IO.inspect(params)
    arg = params |> Map.get("page", []) |> path_join()

    send_download(conn, {:file, @priv_dir <> arg <> "/index.html"}, disposition: :inline)
  end

  defp path_join([]), do: ""
  defp path_join(path), do: Path.join(path)
end
