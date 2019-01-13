defmodule RisoWeb.Mutations.AuthMutations do
  use Absinthe.Schema.Notation

  import RisoWeb.Helpers.ValidationMessageHelpers

  alias RisoWeb.Schema.Middleware
  alias RisoWeb.Email
  alias Riso.{Accounts, Confirmations, Mailer}

  input_object :sign_in_input do
    field(:email, :string)
    field(:password, :string)
  end

  object :auth_mutations do
    @desc "Sign in"
    field :sign_in, :session_payload do
      arg(:input, :sign_in_input)

      resolve(fn args, %{context: context} ->
        input = args[:input]

        with {:ok, user} <- Accounts.authenticate(input[:email], input[:password]),
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

    @desc "Refresh token"
    field :refresh_token, :session_payload do
      arg(:token, :string)

      resolve(fn args, %{context: context} ->
        with {:ok, _, {new_jwt, new_claims}} <-
               Accounts.Guardian.refresh(args[:token], ttl: {30, :days}),
             {:ok, user} <- Accounts.Guardian.resource_from_claims(new_claims),
             Accounts.update_access_token(user, new_jwt),
             {:ok, _} <- Accounts.update_tracked_fields(user, context[:remote_ip]) do
          {:ok, %{token: new_jwt}}
        else
          {:error, %Jason.DecodeError{}} ->
            {:ok, generic_message("bad jwt")}

          {:error, :token_expired} ->
            {:ok, generic_message("Your token has beed expired, please login")}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          nil ->
            {:error, "Not found"}

          _ ->
            {:error, "Not found"}
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
