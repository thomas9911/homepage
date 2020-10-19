defmodule Main.Guardian do
  use Guardian, otp_app: :main

  def subject_for_token(user, _claims) do
    {:ok, user |> Map.get("id", "") |> to_string()}
  end

  def resource_from_claims(%{"sub" => id}) do
    Main.get_user(id)
  end
end
