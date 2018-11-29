defmodule RisoWeb.Mutations.AuthMutations do
  use Absinthe.Schema.Notation

  import RisoWeb.Helpers.ValidationMessageHelpers

  alias RisoWeb.Schema.Middleware
  alias RisoWeb.Email
  alias Riso.{Accounts, Confirmations, Mailer}

  object :auth_mutations do
    @desc "Sign in"
    field :sign_in, :session_payload do
      arg(:email, :string)
      arg(:password, :string)

      resolve(fn args, %{context: context} ->
        with {:ok, user} <- Accounts.authenticate(args[:email], args[:password]),
             true <- Confirmations.confirmed?(user),
             {:ok, token, _} <- Accounts.generate_access_token(user) do
          user |> Accounts.update_tracked_fields(context[:remote_ip])
          {:ok, %{token: token}}
        else
          {:error, :no_yet_confirmed, user_with_new_code} ->
            user_with_new_code |> Email.new_confirmation_code() |> Mailer.deliver_now()
            {:ok, message(:no_yet_confirmed, "The account must be validated.")}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          :error ->
            {:error, generic_message("The email or password invalid.")}
        end
      end)
    end

    @desc "Revoke token"
    field :revoke_token, :boolean do
      middleware(Middleware.Authorize)

      resolve(fn _, %{context: context} ->
        context[:current_user] |> Accounts.revoke_access_token()
        {:ok, true}
      end)
    end
  end
end
