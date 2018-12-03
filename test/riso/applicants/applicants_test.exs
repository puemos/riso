defmodule Riso.ApplicantsTest do
  use Riso.DataCase

  alias Riso.Repo
  alias Riso.PositionsTest
  alias Riso.Positions
  alias Riso.Applicants
  alias Riso.Applicants.Applicant

  describe "applicants" do
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def applicant_fixture(attrs \\ %{}) do
      {:ok, applicant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Applicants.create_applicant()

      applicant
    end

    @tag mustexec: true
    test "set applicant's position" do
      position = PositionsTest.position_fixture()
      applicant = applicant_fixture() |> Repo.preload(:position)

      assert applicant.position == nil
      {:ok, applicant} = Applicants.set_position(applicant, position)
      assert applicant.position.id == position.id
    end

    @tag mustexec: true
    test "set applicant's position stage" do
      position = PositionsTest.position_fixture()

      {:ok, position_stage} =
        Positions.create_position_stage(%{position_id: position.id, title: "super test"})

      applicant = applicant_fixture() |> Repo.preload(:position_stage)

      assert applicant.position_stage == nil
      {:ok, applicant} = Applicants.set_position_stage(applicant, position_stage)
      assert applicant.position_stage.id == position_stage.id
    end

    test "list_applicants/0 returns all applicants" do
      applicant = applicant_fixture()
      assert Applicants.list_applicants() == [applicant]
    end

    test "get_applicant/1 returns the applicant with given id" do
      applicant = applicant_fixture()
      assert Applicants.get_applicant(applicant.id) == applicant
    end

    test "create_applicant/1 with valid data creates a applicant" do
      assert {:ok, %Applicant{} = applicant} = Applicants.create_applicant(@valid_attrs)
      assert applicant.name == "some name"
    end

    test "create_applicant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applicants.create_applicant(@invalid_attrs)
    end

    test "update_applicant/2 with valid data updates the applicant" do
      applicant = applicant_fixture()

      assert {:ok, %Applicant{} = applicant} =
               Applicants.update_applicant(applicant, @update_attrs)

      assert applicant.name == "some updated name"
    end

    test "update_applicant/2 with invalid data returns error changeset" do
      applicant = applicant_fixture()
      assert {:error, %Ecto.Changeset{}} = Applicants.update_applicant(applicant, @invalid_attrs)
      assert applicant == Applicants.get_applicant(applicant.id)
    end

    test "delete_applicant/1 deletes the applicant" do
      applicant = applicant_fixture()
      assert {:ok, %Applicant{}} = Applicants.delete_applicant(applicant)
      assert nil == Applicants.get_applicant(applicant.id)
    end

    test "change_applicant/1 returns a applicant changeset" do
      applicant = applicant_fixture()
      assert %Ecto.Changeset{} = Applicants.change_applicant(applicant)
    end
  end
end
