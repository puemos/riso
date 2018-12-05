defmodule Seeds do
  alias Faker
  alias Riso.Repo
  alias Riso.Applicants
  alias Riso.Applicants.Applicant
  alias Riso.Accounts
  alias Riso.Accounts.User
  alias Riso.Positions
  alias Riso.Kpis
  alias Riso.Positions.Position

  def create_kpi(args) do
    {:ok, kpi} = Kpis.create_kpi(args)
    kpi
  end

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

  def create_position(title) do
    {:ok, position} =
      Positions.create_position(%{
        title: title
      })

    Positions.create_position_stage(%{position_id: position.id, title: "Homework"})
    Positions.create_position_stage(%{position_id: position.id, title: "HR interview"})
    Positions.create_position_stage(%{position_id: position.id, title: "Insite tech interview"})

    Positions.get_position(position.id) |> Repo.preload(:stages)
  end

  def seed_positions() do
    Position |> Repo.delete_all()

    be = create_position("Back-end developer")
    devops = create_position("Devops developer")
    fe = create_position("Front-end developer")
    ml = create_position("ML developer")
    cto = create_position("CTO")
    sys_admin = create_position("System admin")

    %{
      be: be,
      devops: devops,
      fe: fe,
      ml: ml,
      cto: cto,
      sys_admin: sys_admin
    }
  end

  def seed_applicants() do
    Applicant |> Repo.delete_all()

    applicant_1 = create_applicant(%{name: Faker.Name.name()})
    applicant_2 = create_applicant(%{name: Faker.Name.name()})
    applicant_3 = create_applicant(%{name: Faker.Name.name()})
    applicant_4 = create_applicant(%{name: Faker.Name.name()})
    applicant_5 = create_applicant(%{name: Faker.Name.name()})
    applicant_6 = create_applicant(%{name: Faker.Name.name()})
    applicant_7 = create_applicant(%{name: Faker.Name.name()})
    applicant_8 = create_applicant(%{name: Faker.Name.name()})
    applicant_9 = create_applicant(%{name: Faker.Name.name()})

    {
      applicant_1,
      applicant_2,
      applicant_3,
      applicant_4,
      applicant_5,
      applicant_6,
      applicant_7,
      applicant_8,
      applicant_9
    }
  end

  def seed_users do
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

    %{
      user_1: user_1,
      user_2: user_2
    }
  end

  def seed_kpis do
    coding = create_kpi(%{title: "Coding skills"})
    problem = create_kpi(%{title: "Problem solving"})
    algo = create_kpi(%{title: "Algo"})
    elixir = create_kpi(%{title: "Elixir"})
    javascript = create_kpi(%{title: "Javascript"})
    networking = create_kpi(%{title: "Networking"})

    %{
      coding: coding,
      problem: problem,
      algo: algo,
      elixir: elixir,
      networking: networking,
      javascript: javascript
    }
  end

  def run do
    users = seed_users()
    applicants = seed_applicants()
    kpis = seed_kpis()
    positions = seed_positions()

    # Postion Backend
    Positions.add_member(positions.be, users.user_1, "editor")
    Positions.add_kpi(positions.be, kpis.coding)
    Positions.add_kpi(positions.be, kpis.algo)
    Positions.add_kpi(positions.be, kpis.problem)
    Positions.add_kpi(positions.be, kpis.elixir)
    Applicants.set_position_stage(elem(applicants, 0), Enum.at(positions.be.stages, 0))
    Applicants.set_position_stage(elem(applicants, 1), Enum.at(positions.be.stages, 0))
    Applicants.set_position_stage(elem(applicants, 2), Enum.at(positions.be.stages, 1))

    # Postion System admin
    Positions.add_member(positions.sys_admin, users.user_1, "editor")
    Positions.add_kpi(positions.sys_admin, kpis.coding)
    Positions.add_kpi(positions.sys_admin, kpis.problem)
    Positions.add_kpi(positions.sys_admin, kpis.networking)
    Applicants.set_position_stage(elem(applicants, 3), Enum.at(positions.sys_admin.stages, 0))
    Applicants.set_position_stage(elem(applicants, 4), Enum.at(positions.sys_admin.stages, 1))

    # Postion Frontend
    Positions.add_member(positions.fe, users.user_2, "editor")
    Positions.add_kpi(positions.fe, kpis.coding)
    Positions.add_kpi(positions.fe, kpis.algo)
    Positions.add_kpi(positions.fe, kpis.problem)
    Positions.add_kpi(positions.fe, kpis.javascript)
    Applicants.set_position_stage(elem(applicants, 5), Enum.at(positions.fe.stages, 0))
    Applicants.set_position_stage(elem(applicants, 6), Enum.at(positions.fe.stages, 1))
  end
end

Seeds.run()
