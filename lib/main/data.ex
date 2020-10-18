defmodule Main.Data do
  @backend Main.CouchDB

  def new_user(name, password) do
    @backend.create_user(name, Argon2.hash_pwd_salt(password)) |> IO.inspect()
  end

  def login(name, password) do
    case @backend.get_user(name) |> IO.inspect(label: "data") do
      {:ok, [user]} -> {:ok, check_password(user, password)}
      {:ok, []} -> {:error, "user not found"}
      e -> e
    end
  end

  defp check_password(%{"password" => stored_password} = user, password) do
    valid = Argon2.verify_pass(password, stored_password)

    if valid do
      Map.put(user, "valid", valid)
    else
      %{valid: false}
    end
  end
end
