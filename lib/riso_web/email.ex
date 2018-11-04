defmodule RisoWeb.Email do
  use Bamboo.Phoenix, view: RisoWeb.EmailView
  alias Riso.Accounts.User

  @noreply "noreply@riso.com"

  def welcome(%User{} = user) do
    new_email()
    |> to(user.email)
    |> from(@noreply)
    |> subject("Bienvenue sur Riso !")
    |> assign(:user, user)
    |> render(:welcome)
  end

  def new_confirmation_code(%User{} = user) do
    new_email()
    |> to(user.email)
    |> from(@noreply)
    |> subject("Nouveau code pour valider votre compte")
    |> assign(:user, user)
    |> render(:new_confirmation_code)
  end
end
