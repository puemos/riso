defmodule RisoWeb.Mutations.AccountsMutations do
  use Absinthe.Schema.Notation

  import RisoWeb.Helpers.ValidationMessageHelpers

  alias RisoWeb.Schema.Middleware
  alias RisoWeb.Email
  alias Riso.{Accounts, Confirmations, Mailer}

  input_object :sign_up_input do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string)
    field(:password_confirmation, :string)
  end

  input_object :update_user_input do
    field(:name, :string)
    field(:email, :string)
  end

  input_object :change_password_input do
    field(:password, :string)
    field(:password_confirmation, :string)
    field(:current_password, :string)
  end

  input_object :confirm_account_input do
    field(:email, non_null(:string))
    field(:code, non_null(:string))
  end

  input_object :resend_confirmation_input do
    field(:email, non_null(:string))
  end

  object :accounts_mutations do
    @desc "Sign up"
    field :sign_up, :user_payload do
      arg(:input, :sign_up_input)

      resolve(fn args, _ ->
        with {:ok, created_user} <- Accounts.create_user(args[:input]),
             {:ok, _code, user_with_code} <-
               Confirmations.generate_confirmation_code(created_user),
             %Bamboo.Email{} = welcome_email <- Email.welcome(user_with_code) do
          Mailer.deliver_now(welcome_email)
          {:ok, user_with_code}
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          _ -> {:ok, generic_message("Ops, error")}
        end
      end)
    end

    @desc "Update current user profile"
    field :update_user, :user_payload do
      arg(:input, :update_user_input)

      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        case context[:current_user] |> Accounts.update_user(args[:input]) do
          {:ok, user} -> {:ok, user}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        end
      end)
    end

    @desc "Change user password"
    field :change_password, :user_payload do
      arg(:input, :change_password_input)
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        input = args[:input]

        with {:ok, _user} <-
               Accounts.authenticate(context[:current_user].email, input[:current_password]),
             {:ok, user} <- context[:current_user] |> Accounts.change_password(input) do
          {:ok, user}
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          {:error, _msg} -> {:ok, message(:current_password, "your password is not valid")}
        end
      end)
    end

    @desc "Cancel Account"
    field :cancel_account, :boolean do
      middleware(Middleware.Authorize)

      resolve(fn _, %{context: context} ->
        context[:current_user] |> Accounts.cancel_account()
        {:ok, true}
      end)
    end

    @desc "confirm account"
    field :confirm_account, :session_payload do
      arg(:input, :confirm_account_input)

      resolve(fn args, %{context: context} ->
        input = args[:input]

        with {:ok, user} <- Accounts.user_by_email(input[:email]),
             {:ok, confirmed_user} <-
               Confirmations.confirm_account(user, input[:code] |> String.trim()),
             {:ok, token, user_with_token} <- Accounts.generate_access_token(confirmed_user),
             {:ok, _tracked_user} <-
               Accounts.update_tracked_fields(user_with_token, context[:remote_ip]) do
          {:ok, %{token: token}}
        else
          {:error, %Ecto.Query{} = _query} ->
            {:ok, generic_message("The email #{input[:email]} was not found")}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          _ ->
            {:ok, generic_message("Ops, error")}
        end
      end)
    end

    @desc "Resend confirmation"
    field :resend_confirmation, :boolean_payload do
      arg(:input, :resend_confirmation_input)

      resolve(fn args, _ ->
        input = args[:input]

        with {:ok, user} <- Accounts.user_by_email(input[:email]),
             {:ok, _code, user_with_code} <- Confirmations.generate_confirmation_code(user),
             %Bamboo.Email{} = confirmation_email <- Email.new_confirmation_code(user_with_code) do
          Mailer.deliver_now(confirmation_email)
          {:ok, true}
        else
          {:error, %Ecto.Query{}} ->
            {:ok, generic_message("The email #{input[:email]} was not found")}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          _ ->
            {:ok, generic_message("Ops, error")}
        end
      end)
    end
  end
end
