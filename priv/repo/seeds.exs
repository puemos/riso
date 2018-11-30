defmodule Seeds do
  alias Faker
  alias Riso.Repo
  alias Riso.Accounts
  alias Riso.Accounts.User
  alias Riso.Positions
  alias Riso.Positions.PositionMember
  alias Riso.Positions.Position

  def create_user(args) do
    {:ok, unconfirmed_user} = Accounts.create_user(args)
    {:ok, code, user_with_code} = Riso.Confirmations.generate_confirmation_code(unconfirmed_user)
    {:ok, user} = Riso.Confirmations.confirm_account(user_with_code, code)
    user
  end

  def create_position(user, title) do
    {:ok, position} =
      Positions.create_position(%{
        title: title
      })

    Positions.add_member(position, user, "editor")

    Positions.create_position_kpi(%{position_id: position.id, title: Faker.Industry.En.industry()})
    Positions.create_position_kpi(%{position_id: position.id, title: Faker.Industry.En.industry()})
    Positions.create_position_kpi(%{position_id: position.id, title: Faker.Industry.En.industry()})

    Positions.create_position_stage(%{position_id: position.id, title: Faker.Name.name()})
    Positions.create_position_stage(%{position_id: position.id, title: Faker.Name.name()})
    Positions.create_position_stage(%{position_id: position.id, title: Faker.Name.name()})
    position
  end

  def run do

    User |> Repo.delete_all()
    user_1 = create_user(%{name: Faker.StarWars.character(), email: "user_1@riso.com", password: "password", password_confirmation: "password"})
    user_2 = create_user(%{name: Faker.StarWars.character(), email: "user_2@riso.com", password: "password", password_confirmation: "password"})

    Position |> Repo.delete_all()
    create_position(user_1, Faker.Industry.sub_sector())
    create_position(user_1, Faker.Industry.sub_sector())
    create_position(user_1, Faker.Industry.sub_sector())
    create_position(user_1, Faker.Industry.sub_sector())
    create_position(user_2, Faker.Industry.sub_sector())
    create_position(user_2, Faker.Industry.sub_sector())
    create_position(user_2, Faker.Industry.sub_sector())
  end

end

Seeds.run()
