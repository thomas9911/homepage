defmodule Main.Data do
  # @backend Main.CouchDB

  # @empty_user %{
  #   valid: false,
  #   jwt: nil
  # }

  # def new_user(name, password) do
  #   @backend.create_user(name, Argon2.hash_pwd_salt(password))
  # end

  # defdelegate get_user(id), to: Main.CouchDB

  # def login(name, password) do
  #   case @backend.get_user(name) do
  #     {:ok, [user]} -> {:ok, check_password(user, password)}
  #     {:ok, []} -> {:ok, @empty_user}
  #     e -> e
  #   end
  # end

  # defp check_password(%{"password" => stored_password} = user, password) do
  #   valid = Argon2.verify_pass(password, stored_password)

  #   if valid do
  #     {:ok, token, _full_claims} = Main.Guardian.encode_and_sign(user)

  #     user
  #     |> Map.put(:valid, valid)
  #     |> Map.put(:jwt, token)
  #   else
  #     @empty_user
  #   end
  # end
end
