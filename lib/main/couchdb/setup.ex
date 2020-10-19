defmodule Main.CouchDB.Setup do
  defdelegate up(), to: Main.CouchDB.Setup.Up, as: :setup
  defdelegate down(), to: Main.CouchDB.Setup.Down, as: :drop
end
