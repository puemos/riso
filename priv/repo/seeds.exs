# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Riso.Repo.insert!(%Riso.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# credo:disable-for-this-file

alias Riso.Repo
alias Riso.Accounts
alias Riso.Accounts.User
alias Riso.Campaigns
alias Riso.Campaigns.Campaign

images_path = Riso.ReleaseTasks.priv_path_for(Riso.Repo, "images")

User |> Repo.delete_all()
{:ok, unconfirmed_user} = Accounts.create_user(%{name: "Shy", email: "shy@riso.com", password: "password", password_confirmation: "password"})
{:ok, code, user_with_code} = Riso.Confirmations.generate_confirmation_code(unconfirmed_user)
{:ok, user} = Riso.Confirmations.confirm_account(user_with_code, code)

Campaign |> Repo.delete_all()

Campaigns.change_campaign(%{
  name: "DevOps developer",
  users: [user]
})
