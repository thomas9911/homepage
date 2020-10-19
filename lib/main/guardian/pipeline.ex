defmodule Main.Guardian.Pipeline do
  # use Guardian, otp_app: :main

  # def subject_for_token(user, _claims) do
  #   {:ok, user |> Map.get("id", "") |> to_string()}
  # end

  # def resource_from_claims(%{"sub" => id}) do
  #   Main.get_user(id)
  # end

  use Guardian.Plug.Pipeline,
    otp_app: :main,
    error_handler: Main.Guardian.ErrorHandler,
    module: Main.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
