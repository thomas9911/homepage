defmodule Mix.Tasks.Drop do
  @moduledoc "Runs the drop migration of CouchDB"
  @shortdoc "Runs the drop migration of CouchDB"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Main.CouchDB.Setup.down()
  end
end
