defmodule Main do
  @moduledoc """
  Main keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @backend Main.CouchDB

  @empty_user %{
    valid: false,
    jwt: nil,
    expires_at: nil
  }

  def new_user(name, password) do
    @backend.create_user(name, Argon2.hash_pwd_salt(password))
  end

  defdelegate get_user(id), to: @backend
  defdelegate get_user_by_name(name), to: @backend

  def login(name, password) do
    case get_user_by_name(name) do
      {:ok, [user]} -> {:ok, check_password(user, password)}
      {:ok, []} -> {:ok, @empty_user}
      e -> e
    end
  end

  defdelegate new_post(user_id, data), to: @backend, as: :create_post
  defdelegate list_posts(opts \\ []), to: @backend

  defp check_password(%{"password" => stored_password} = user, password) do
    valid = Argon2.verify_pass(password, stored_password)

    if valid do
      {:ok, token, %{"exp" => exp}} = Main.Guardian.encode_and_sign(user)

      user
      |> Map.put(:valid, valid)
      |> Map.put(:jwt, token)
      |> Map.put(:expires_at, exp |> DateTime.from_unix!() |> DateTime.to_iso8601())
    else
      @empty_user
    end
  end
end
