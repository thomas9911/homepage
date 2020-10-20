defmodule Main.CouchDB.Setup do
  require Logger

  defdelegate up(), to: Main.CouchDB.Setup.Up, as: :setup
  defdelegate down(), to: Main.CouchDB.Setup.Down, as: :drop

  def print(message) do
    Logger.bare_log(level(), message)
  end

  def print_success({:ok, %{body: %{"error" => _, "reason" => reason}}}) do
    print("failed, because #{inspect(reason)}")
  end

  def print_success({:ok, _}) do
    print("success")
  end

  def print_success(_) do
    print("failed")
  end

  defp level do
    Application.get_env(:main, __MODULE__, log_level: :debug)[:log_level]
  end
end
