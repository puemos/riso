defmodule Seeds do
  alias Faker
  alias Riso.Repo
  alias Riso.Applicants
  alias Riso.Applicants.Applicant
  alias Riso.Accounts
  alias Riso.Accounts.User
  alias Riso.Positions
  alias Riso.Positions.Position
  alias Riso.Kpis
  alias Riso.Organizations
  alias Riso.Organizations.Organization

  def create_organization(args) do
    {:ok, organization} = Organizations.create_organization(args)
    organization
  end

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

  def create_applicant_review(args) do
    {:ok, applicant_review} = Applicants.create_applicant_review(args)
    applicant_review
  end

  def create_position(args) do
    {:ok, position} = Positions.create_position(args)

    Positions.create_position_stage(%{position_id: position.id, title: "Homework"})
    Positions.create_position_stage(%{position_id: position.id, title: "HR interview"})
    Positions.create_position_stage(%{position_id: position.id, title: "Insite tech interview"})

    Positions.get_position(position.id) |> Repo.preload(:stages)
  end

  def seed_organizations() do
    Organization |> Repo.delete_all()

    pied_piper = create_organization(%{name: "Pied Piper"})
    hooli = create_organization(%{name: "Hooli Corp."})

    %{
      pied_piper: pied_piper,
      hooli: hooli
    }
  end

  def seed_positions(orgs) do
    Position |> Repo.delete_all()

    be = create_position(%{title: "Back-end developer", organization_id: orgs.hooli.id})
    devops = create_position(%{title: "Devops developer", organization_id: orgs.hooli.id})
    fe = create_position(%{title: "Front-end developer", organization_id: orgs.hooli.id})
    ml = create_position(%{title: "ML developer", organization_id: orgs.hooli.id})

    cto = create_position(%{title: "CTO", organization_id: orgs.pied_piper.id})
    sys_admin = create_position(%{title: "System admin", organization_id: orgs.pied_piper.id})

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

    applicant_1 =
      create_applicant(%{name: Faker.Name.name(), photo: Faker.Avatar.image_url(60, 60)})

    applicant_2 =
      create_applicant(%{name: Faker.Name.name(), photo: Faker.Avatar.image_url(60, 60)})

    applicant_3 =
      create_applicant(%{name: Faker.Name.name(), photo: Faker.Avatar.image_url(60, 60)})

    applicant_4 =
      create_applicant(%{name: Faker.Name.name(), photo: Faker.Avatar.image_url(60, 60)})

    applicant_5 =
      create_applicant(%{name: Faker.Name.name(), photo: Faker.Avatar.image_url(60, 60)})

    applicant_6 =
      create_applicant(%{name: Faker.Name.name(), photo: Faker.Avatar.image_url(60, 60)})

    applicant_7 =
      create_applicant(%{name: Faker.Name.name(), photo: Faker.Avatar.image_url(60, 60)})

    applicant_8 =
      create_applicant(%{name: Faker.Name.name(), photo: Faker.Avatar.image_url(60, 60)})

    applicant_9 =
      create_applicant(%{name: Faker.Name.name(), photo: Faker.Avatar.image_url(60, 60)})

    %{
      applicant_1: applicant_1,
      applicant_2: applicant_2,
      applicant_3: applicant_3,
      applicant_4: applicant_4,
      applicant_5: applicant_5,
      applicant_6: applicant_6,
      applicant_7: applicant_7,
      applicant_8: applicant_8,
      applicant_9: applicant_9
    }
  end

  def seed_users do
    User |> Repo.delete_all()

    user_1 =
      create_user(%{
        name: "user_1",
        email: "user_1@riso.com",
        password: "password",
        password_confirmation: "password"
      })

    user_2 =
      create_user(%{
        name: "user_2",
        email: "user_2@riso.com",
        password: "password",
        password_confirmation: "password"
      })

    user_3 =
      create_user(%{
        name: "user_3",
        email: "user_3@riso.com",
        password: "password",
        password_confirmation: "password"
      })

    %{
      user_1: user_1,
      user_2: user_2,
      user_3: user_3
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
    aplcs = seed_applicants()
    kpis = seed_kpis()
    orgs = seed_organizations()
    pos = seed_positions(orgs)

    Organizations.add_member(orgs.pied_piper, users.user_1, "editor")
    Organizations.add_member(orgs.hooli, users.user_2, "editor")
    Organizations.add_member(orgs.hooli, users.user_3, "viewer")

    # Postion Backend (hooli)
    Positions.add_member(pos.be, users.user_2, "editor")

    Positions.add_kpi(pos.be, kpis.coding)
    Positions.add_kpi(pos.be, kpis.algo)
    Positions.add_kpi(pos.be, kpis.problem)
    Positions.add_kpi(pos.be, kpis.elixir)

    Applicants.set_position(aplcs.applicant_1, pos.be)
    Applicants.set_position_stage(aplcs.applicant_1, Enum.at(pos.be.stages, 0))

    Applicants.set_position(aplcs.applicant_2, pos.be)
    Applicants.set_position_stage(aplcs.applicant_2, Enum.at(pos.be.stages, 0))

    Applicants.set_position(aplcs.applicant_3, pos.be)
    Applicants.set_position_stage(aplcs.applicant_3, Enum.at(pos.be.stages, 1))

    create_applicant_review(%{
      reviewer_id: users.user_2.id,
      applicant_id: aplcs.applicant_2.id,
      position_id: pos.be.id,
      kpi_id: kpis.coding.id,
      score: 2
    })

    create_applicant_review(%{
      reviewer_id: users.user_2.id,
      applicant_id: aplcs.applicant_2.id,
      position_id: pos.be.id,
      kpi_id: kpis.algo.id,
      score: 7
    })

    # Postion System admin (pied piper)
    Positions.add_member(pos.sys_admin, users.user_1, "editor")
    Positions.add_kpi(pos.sys_admin, kpis.coding)
    Positions.add_kpi(pos.sys_admin, kpis.problem)
    Positions.add_kpi(pos.sys_admin, kpis.networking)

    Applicants.set_position(aplcs.applicant_4, pos.sys_admin)
    Applicants.set_position_stage(aplcs.applicant_4, Enum.at(pos.sys_admin.stages, 0))

    Applicants.set_position(aplcs.applicant_5, pos.sys_admin)
    Applicants.set_position_stage(aplcs.applicant_5, Enum.at(pos.sys_admin.stages, 1))

    create_applicant_review(%{
      reviewer_id: users.user_1.id,
      applicant_id: aplcs.applicant_4.id,
      position_id: pos.sys_admin.id,
      kpi_id: kpis.coding.id,
      score: 2
    })

    create_applicant_review(%{
      reviewer_id: users.user_1.id,
      applicant_id: aplcs.applicant_4.id,
      position_id: pos.sys_admin.id,
      kpi_id: kpis.networking.id,
      score: 7
    })

    # Postion Frontend (hooli)
    Positions.add_member(pos.fe, users.user_2, "editor")
    Positions.add_kpi(pos.fe, kpis.coding)
    Positions.add_kpi(pos.fe, kpis.algo)
    Positions.add_kpi(pos.fe, kpis.problem)
    Positions.add_kpi(pos.fe, kpis.javascript)

    Applicants.set_position(aplcs.applicant_6, pos.fe)
    Applicants.set_position_stage(aplcs.applicant_6, Enum.at(pos.fe.stages, 0))

    Applicants.set_position(aplcs.applicant_7, pos.fe)
    Applicants.set_position_stage(aplcs.applicant_7, Enum.at(pos.fe.stages, 1))

    Applicants.set_position(aplcs.applicant_8, pos.fe)
    Applicants.set_position_stage(aplcs.applicant_8, Enum.at(pos.fe.stages, 1))

    Applicants.set_position(aplcs.applicant_9, pos.fe)
    Applicants.set_position_stage(aplcs.applicant_9, Enum.at(pos.fe.stages, 1))
  end
end

Seeds.run()
