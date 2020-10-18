defmodule Mix.Tasks.Setup do
    @moduledoc "Runs the migration of CouchDB"
    @shortdoc "Runs the migration of CouchDB"
  
    use Mix.Task
  
    @impl Mix.Task
    def run(_args) do
        Main.CouchDB.Setup.setup()
    end
  end