defmodule MainWeb.PageController do
  use MainWeb, :controller

  # @priv_dir :code.priv_dir(:main) |> to_string()
  @priv_dir "./priv/static"

  def index(conn, params) do
    file = file_path(params)

    send_download(conn, {:file, file}, disposition: :inline)
  rescue
    File.Error ->
      conn
      |> put_status(:not_found)
      |> put_view(MainWeb.ErrorView)
      |> render(:"404")
  end

  defp file_path(params) do
    arg = params |> Map.get("page", []) |> path_join()

    Path.join([
      @priv_dir,
      arg,
      "index.html"
    ])
  end

  defp path_join([]), do: ""
  defp path_join(path), do: Path.join(path)
end
