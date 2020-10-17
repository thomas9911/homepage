defmodule Mix.Tasks.Fauxton do
  @moduledoc "Opens CouchDb admin frontend in the default browser"
  @shortdoc "Opens CouchDb admin frontend"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Mix.shell().cmd("start #{couchdb_url()}/_utils")
  end

  defp couchdb_url() do
    Application.fetch_env!(:main, Main.CouchDB)[:url]
  end
end
