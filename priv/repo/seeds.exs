alias Riso.Repo
alias Riso.Accounts
alias Riso.Accounts.User
alias Riso.Positions
alias Riso.Positions.PositionMember
alias Riso.Positions.Position

PositionMember |> Repo.delete_all()

User |> Repo.delete_all()
{:ok, unconfirmed_user} = Accounts.create_user(%{name: "Shy", email: "shy@riso.com", password: "password", password_confirmation: "password"})
{:ok, code, user_with_code} = Riso.Confirmations.generate_confirmation_code(unconfirmed_user)
{:ok, user} = Riso.Confirmations.confirm_account(user_with_code, code)

Position |> Repo.delete_all()

Positions.create(user, %{
  title: "DevOps developer"
})
