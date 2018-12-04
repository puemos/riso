defmodule Riso.PositionsTest do
  use Riso.DataCase

  alias Riso.Repo
  alias Riso.Positions

  @user_valid_attrs %{
    name: "name",
    email: "email@riso.com",
    password: "password",
    password_confirmation: "password"
  }

  @position_valid_attrs %{title: "some title"}
  # @position_update_attrs %{title: "some updated title"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_valid_attrs)
      |> Riso.Accounts.create_user()

    user
  end

  def position_fixture(attrs \\ %{}) do
    {:ok, position} =
      attrs
      |> Enum.into(@position_valid_attrs)
      |> Positions.create_position()

    position
  end

  describe "position" do
    test "should create a position" do
      position = position_fixture()
      assert position.title == "some title"
    end

    test "should get a position by id" do
      position = position_fixture()
      position_after = Positions.get_position(position.id)
      assert position.id == position_after.id
    end
  end

  describe "position members" do
    test "should add a member to a position" do
      position = position_fixture()
      user = user_fixture()

      Positions.add_member(position, user, "viewer")
      position_after = Positions.get_position(position.id)
      position_after = Repo.preload(position_after, :members)

      viewer =
        Enum.find(
          position_after.members,
          fn member ->
            member.user_id == user.id and member.role == "viewer"
          end
        )

      assert viewer.user_id == user.id
      assert viewer.role == "viewer"
    end

    test "should not add a member with custom role" do
      position = position_fixture()
      user = user_fixture()

      assert {:error, _} = Positions.add_member(position, user, "custom")
    end

    test "should not add a member with the same role" do
      position = position_fixture()
      user = user_fixture()
      Positions.add_member(position, user, "viewer")
      assert {:error, _} = Positions.add_member(position, user, "viewer")
    end

    test "should add a member with 2 roles to a position" do
      position = position_fixture()
      user = user_fixture()

      Positions.add_member(position, user, "viewer")
      Positions.add_member(position, user, "editor")

      position_after =
        Positions.get_position(position.id)
        |> Repo.preload(:members)

      editor =
        Enum.find(
          position_after.members,
          fn member ->
            member.user_id == user.id and member.role == "editor"
          end
        )

      assert editor.user_id == user.id
      assert editor.role == "editor"

      viewer =
        Enum.find(
          position_after.members,
          fn member ->
            member.user_id == user.id and member.role == "viewer"
          end
        )

      assert viewer.user_id == user.id
      assert viewer.role == "viewer"
    end
  end

  describe "position stages" do
    test "should create and add a stage to a position" do
      position = position_fixture()

      {:ok, _} = Positions.create_position_stage(%{position_id: position.id, title: "super test"})

      position_after = Positions.get_position(position.id)
      position_after = Repo.preload(position_after, :stages)

      stage = Enum.at(position_after.stages, 0)

      assert stage.position_id == position.id
      assert stage.title == "super test"
    end

    test "should fail to create a position stage with no position id" do
      assert {:error, changeset} = Positions.create_position_stage(%{title: "super test"})
    end

    test "should update a position stage" do
      position = position_fixture()

      {:ok, position_stage} =
        Positions.create_position_stage(%{position_id: position.id, title: "super test"})

      Positions.update_position_stage(position_stage, %{title: "updated title"})
      position_stage_after = Positions.get_position_stage(position_stage.id)

      assert position_stage_after.title != position_stage.title
      assert position_stage_after.title == "updated title"
    end

    test "should delete a position stage" do
      position = position_fixture()

      {:ok, position_stage} =
        Positions.create_position_stage(%{position_id: position.id, title: "super test"})

      assert Positions.get_position_stage(position_stage.id)
      Positions.delete_position_stage(position_stage)
      assert nil == Positions.get_position_stage(position_stage.id)
    end
  end

  describe "position kpis" do
    test "should create and add a kpi to a position" do
      position = position_fixture()

      {:ok, _} = Positions.create_position_kpi(%{position_id: position.id, title: "super test"})

      position_after = Positions.get_position(position.id)
      position_after = Repo.preload(position_after, :kpis)

      kpi = Enum.at(position_after.kpis, 0)

      assert kpi.position_id == position.id
      assert kpi.title == "super test"
    end

    test "should fail to create a position kpi with no position id" do
      assert {:error, changeset} = Positions.create_position_kpi(%{title: "super test"})
    end

    test "should update a position kpi" do
      position = position_fixture()

      {:ok, position_kpi} =
        Positions.create_position_kpi(%{position_id: position.id, title: "super test"})

      Positions.update_position_kpi(position_kpi, %{title: "updated title"})
      position_kpi_after = Positions.get_position_kpi(position_kpi.id)

      assert position_kpi_after.title != position_kpi.title
      assert position_kpi_after.title == "updated title"
    end

    test "should delete a position kpi" do
      position = position_fixture()

      {:ok, position_kpi} =
        Positions.create_position_kpi(%{position_id: position.id, title: "super test"})

      assert Positions.get_position_kpi(position_kpi.id)
      Positions.delete_position_kpi(position_kpi)
      assert nil == Positions.get_position_kpi(position_kpi.id)
    end
  end
end
