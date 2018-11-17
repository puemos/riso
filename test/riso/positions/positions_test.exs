defmodule Riso.PositionsTest do
  use Riso.DataCase

  alias Riso.Positions
  alias Riso.Positions.{Position, Stage, PositionMember}
  alias Riso.Accounts.User

  describe "positions" do
    @user_attrs %{name: "name", email: "email@riso.com", password: "password", password_confirmation: "password"}

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def user_fixture(attrs \\ %{}) do
      attrs = attrs |> Enum.into(@user_attrs)
      {:ok, user} = Riso.Accounts.create_user(attrs)
      user
    end

    def position_fixture(attrs \\ %{}, user \\ %User{}) do
      attrs = attrs |> Enum.into(@valid_attrs)
      {:ok, position} = Positions.create(user, attrs)

      position
    end

    test "search/0 returns all positions" do
      position = position_fixture()
      res = Position |> Positions.search("") |> Repo.all()
      assert res == [position]
    end

    test "create/1 with valid data creates a position" do
      assert {:ok, position} = Positions.create(%User{}, @valid_attrs)
      assert position.title == "some title"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Positions.create(%User{}, @invalid_attrs)
    end

    test "update/2 with valid data updates the position" do
      position = position_fixture()
      assert {:ok, position} = Positions.update(position, @update_attrs)
      assert %Position{} = position
      assert position.title == "some updated title"
    end

    test "update/2 with invalid data returns error changeset" do
      position = position_fixture()
      assert {:error, %Ecto.Changeset{}} = Positions.update(position, @invalid_attrs)
      assert position == Positions.get!(position.id)
    end

    test "delete/1 deletes the position" do
      position = position_fixture()
      assert {:ok, %Position{}} = Positions.delete(position)
      assert_raise Ecto.NoResultsError, fn -> Positions.get!(position.id) end
    end

    test "change/1 returns a position changeset" do
      position = position_fixture()
      assert %Ecto.Changeset{} = Positions.change(position)
    end
  end

  describe "stages" do
    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def stage_fixture(attrs \\ %{}, campagin \\ %Position{}) do
      attrs = attrs |> Enum.into(@valid_attrs)
      {:ok, stage} = Positions.create_stage(campagin, attrs)
      stage
    end

    test "create_stage/1 with valid data creates a stage" do
      assert {:ok, %Stage{} = stage} = Positions.create_stage(%Position{}, @valid_attrs)
      assert stage.title == "some title"
    end

    test "create_stage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Positions.create_stage(%Position{}, @invalid_attrs)
    end

    test "update_stage/2 with valid data updates the stage" do
      stage = stage_fixture()
      assert {:ok, stage} = Positions.update_stage(stage, @update_attrs)
      assert %Stage{} = stage
      assert stage.title == "some updated title"
    end

    test "update_stage/2 with invalid data returns error changeset" do
      stage = stage_fixture()
      before_change_stage = Positions.get_stage!(stage.id)
      assert {:error, %Ecto.Changeset{}} = Positions.update_stage(stage, @invalid_attrs)
      assert before_change_stage == Positions.get_stage!(stage.id)
    end

    test "delete_stage/1 deletes the stage" do
      stage = stage_fixture()
      assert {:ok, %Stage{}} = Positions.delete_stage(stage)
      assert_raise Ecto.NoResultsError, fn -> Positions.get_stage!(stage.id) end
    end

    test "change_stage/1 returns a stage changeset" do
      stage = stage_fixture()
      assert %Ecto.Changeset{} = Positions.change_stage(stage)
    end
  end

  describe "positions_members" do
    alias Riso.Positions.PositionMember

    @valid_attrs %{role: "editor"}
    @update_attrs %{role: "viewer"}
    @invalid_attrs %{role: nil}

    def position_member_fixture(attrs \\ %{}) do
      {:ok, position_member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Positions.create_position_member()

      position_member
    end

    test "create_position_member/1 with valid data creates a position_member" do
      u = user_fixture()
      c = position_fixture()

      assert {:ok, %PositionMember{} = position_member} =
               %{user_id: u.id, position_id: c.id}
               |> Enum.into(@valid_attrs)
               |> Positions.create_position_member()

      assert position_member.role == "editor"
    end

    test "create_position_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Positions.create_position_member(@invalid_attrs)
    end

    test "create_position_member/1 with custom role returns error changeset" do
      u = user_fixture()
      c = position_fixture()

      assert {:error, %Ecto.Changeset{}} = Positions.create_position_member(%{user_id: u.id, position_id: c.id, role: "custom"})
    end

    test "update_position_member/2 with valid data updates the position_member" do
      u = user_fixture()
      c = position_fixture()
      position_member = position_member_fixture(%{user_id: u.id, position_id: c.id})

      assert {:ok, position_member} = Positions.update_position_member(position_member, @update_attrs)
      assert %PositionMember{} = position_member
      assert position_member.role == "viewer"
    end

    test "update_position_member/2 with invalid data returns error changeset" do
      u = user_fixture()
      c = position_fixture()
      position_member = position_member_fixture(%{user_id: u.id, position_id: c.id})
      before_update_position_member = Positions.get_position_member!(position_member.id)

      assert {:error, %Ecto.Changeset{}} = Positions.update_position_member(position_member, @invalid_attrs)
      assert before_update_position_member == Positions.get_position_member!(position_member.id)
    end

    test "update_position_member/2 with custom role returns error changeset" do
      u = user_fixture()
      c = position_fixture()
      position_member = position_member_fixture(%{user_id: u.id, position_id: c.id})
      before_update_position_member = Positions.get_position_member!(position_member.id)

      assert {:error, %Ecto.Changeset{}} = Positions.update_position_member(position_member, %{role: "custom"})
      assert before_update_position_member == Positions.get_position_member!(position_member.id)
    end

    test "delete_position_member/1 deletes the position_member" do
      u = user_fixture()
      c = position_fixture()
      position_member = position_member_fixture(%{user_id: u.id, position_id: c.id})
      assert {:ok, %PositionMember{}} = Positions.delete_position_member(position_member)
      assert_raise Ecto.NoResultsError, fn -> Positions.get_position_member!(position_member.id) end
    end
  end
end
