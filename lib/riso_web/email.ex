defmodule RisoWeb.Email do
  use Bamboo.Phoenix, view: RisoWeb.EmailView
  alias Riso.Accounts.User

  @noreply "noreply@riso.com"

  def welcome(%User{} = user) do
    new_email()
    |> to(user.email)
    |> from(@noreply)
    |> subject("Welcome to Riso !")
    |> assign(:user, user)
    |> render(:welcome)
  end

  def new_confirmation_code(%User{} = user) do
    new_email()
    |> to(user.email)
    |> from(@noreply)
    |> subject("Your new code to validate your account")
    |> assign(:user, user)
    |> render(:new_confirmation_code)
  end
end
