defmodule Main.CouchDB.Setup do
  require Logger

  Module.register_attribute(__MODULE__, :data_tables, persist: true)
  @data_tables ["posts"]

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
    Application.get_env(:main, __MODULE__, [])[:log_level] || :debug
  end
end
