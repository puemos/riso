defmodule Seeds do
  alias Faker
  alias Riso.Repo
  alias Riso.Applicants
  alias Riso.Applicants.Applicant
  alias Riso.Accounts
  alias Riso.Accounts.User
  alias Riso.Positions
  alias Riso.Positions.Position

  def create_user(args) do
    {:ok, unconfirmed_user} = Accounts.create_user(args)
    {:ok, code, user_with_code} = Riso.Confirmations.generate_confirmation_code(unconfirmed_user)
    {:ok, user} = Riso.Confirmations.confirm_account(user_with_code, code)
    user
  end

  def create_applicant(args) do
    {:ok, applicant} = Applicants.create_applicant(args)
    applicant
  end

  def create_position(user, title) do
    {:ok, position} =
      Positions.create_position(%{
        title: title
      })

    Positions.add_member(position, user, "editor")

    Positions.create_position_kpi(%{position_id: position.id, title: "Coding skills"})

    Positions.create_position_kpi(%{position_id: position.id, title: "Algo"})

    Positions.create_position_kpi(%{position_id: position.id, title: "Problem solving"})

    {:ok, stage_1} =
      Positions.create_position_stage(%{position_id: position.id, title: "Homework"})

    {:ok, stage_2} =
      Positions.create_position_stage(%{position_id: position.id, title: "HR interview"})

    {:ok, stage_3} =
      Positions.create_position_stage(%{position_id: position.id, title: "Insite tech interview"})

    {
      position,
      {
        stage_1,
        stage_2,
        stage_3
      }
    }
  end

  def run do
    User |> Repo.delete_all()

    user_2 =
      create_user(%{
        name: "user_2",
        email: "user_2@riso.com",
        password: "password",
        password_confirmation: "password"
      })

    user_1 =
      create_user(%{
        name: "user_1",
        email: "user_1@riso.com",
        password: "password",
        password_confirmation: "password"
      })

    Position |> Repo.delete_all()
    {position_1, stages_1} = create_position(user_1, "Back-end developer")
    {position_2, stages_2} = create_position(user_1, "Devops developer")
    {position_3, stages_3} = create_position(user_1, "Front-end developer")

    {_position_4, _stages_4} = create_position(user_2, "Data sciencetist")
    {position_5, stages_5} = create_position(user_2, "Team lead")
    {position_6, stages_6} = create_position(user_2, "VP R&D")

    Applicant |> Repo.delete_all()

    create_applicant(%{name: Faker.Name.name()})
    |> Applicants.set_position(position_1)
    |> elem(1)
    |> Applicants.set_position_stage(elem(stages_1, 0))

    create_applicant(%{name: Faker.Name.name()})
    |> Applicants.set_position(position_1)
    |> elem(1)
    |> Applicants.set_position_stage(elem(stages_1, 0))

    create_applicant(%{name: Faker.Name.name()})
    |> Applicants.set_position(position_2)
    |> elem(1)
    |> Applicants.set_position_stage(elem(stages_2, 1))

    create_applicant(%{name: Faker.Name.name()})
    |> Applicants.set_position(position_3)
    |> elem(1)
    |> Applicants.set_position_stage(elem(stages_3, 0))

    create_applicant(%{name: Faker.Name.name()})
    |> Applicants.set_position(position_5)

    create_applicant(%{name: Faker.Name.name()})
    |> Applicants.set_position(position_5)

    create_applicant(%{name: Faker.Name.name()})
    |> Applicants.set_position(position_5)

    create_applicant(%{name: Faker.Name.name()})
    |> Applicants.set_position(position_6)
    |> elem(1)
    |> Applicants.set_position_stage(elem(stages_6, 2))

    create_applicant(%{name: Faker.Name.name()})
    |> Applicants.set_position(position_6)
    |> elem(1)
    |> Applicants.set_position_stage(elem(stages_6, 2))
  end
end

Seeds.run()
