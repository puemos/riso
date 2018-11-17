defmodule Riso.CampaignsTest do
  use Riso.DataCase

  alias Riso.Campaigns
  alias Riso.Campaigns.{Campaign, Stage, CampaignMember}
  alias Riso.Accounts.User

  describe "campaigns" do
    @user_attrs %{name: "name", email: "email@riso.com", password: "password", password_confirmation: "password"}

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def user_fixture(attrs \\ %{}) do
      attrs = attrs |> Enum.into(@user_attrs)
      {:ok, user} = Riso.Accounts.create_user(attrs)
      user
    end

    def campaign_fixture(attrs \\ %{}, user \\ %User{}) do
      attrs = attrs |> Enum.into(@valid_attrs)
      {:ok, campaign} = Campaigns.create(user, attrs)

      campaign
    end

    test "search/0 returns all campaigns" do
      campaign = campaign_fixture()
      res = Campaign |> Campaigns.search("") |> Repo.all()
      assert res == [campaign]
    end

    test "create/1 with valid data creates a campaign" do
      assert {:ok, campaign} = Campaigns.create(%User{}, @valid_attrs)
      assert campaign.title == "some title"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create(%User{}, @invalid_attrs)
    end

    test "update/2 with valid data updates the campaign" do
      campaign = campaign_fixture()
      assert {:ok, campaign} = Campaigns.update(campaign, @update_attrs)
      assert %Campaign{} = campaign
      assert campaign.title == "some updated title"
    end

    test "update/2 with invalid data returns error changeset" do
      campaign = campaign_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaigns.update(campaign, @invalid_attrs)
      assert campaign == Campaigns.get!(campaign.id)
    end

    test "delete/1 deletes the campaign" do
      campaign = campaign_fixture()
      assert {:ok, %Campaign{}} = Campaigns.delete(campaign)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get!(campaign.id) end
    end

    test "change/1 returns a campaign changeset" do
      campaign = campaign_fixture()
      assert %Ecto.Changeset{} = Campaigns.change(campaign)
    end
  end

  describe "stages" do
    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def stage_fixture(attrs \\ %{}, campagin \\ %Campaign{}) do
      attrs = attrs |> Enum.into(@valid_attrs)
      {:ok, stage} = Campaigns.create_stage(campagin, attrs)
      stage
    end

    test "create_stage/1 with valid data creates a stage" do
      assert {:ok, %Stage{} = stage} = Campaigns.create_stage(%Campaign{}, @valid_attrs)
      assert stage.title == "some title"
    end

    test "create_stage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create_stage(%Campaign{}, @invalid_attrs)
    end

    test "update_stage/2 with valid data updates the stage" do
      stage = stage_fixture()
      assert {:ok, stage} = Campaigns.update_stage(stage, @update_attrs)
      assert %Stage{} = stage
      assert stage.title == "some updated title"
    end

    test "update_stage/2 with invalid data returns error changeset" do
      stage = stage_fixture()
      before_change_stage = Campaigns.get_stage!(stage.id)
      assert {:error, %Ecto.Changeset{}} = Campaigns.update_stage(stage, @invalid_attrs)
      assert before_change_stage == Campaigns.get_stage!(stage.id)
    end

    test "delete_stage/1 deletes the stage" do
      stage = stage_fixture()
      assert {:ok, %Stage{}} = Campaigns.delete_stage(stage)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get_stage!(stage.id) end
    end

    test "change_stage/1 returns a stage changeset" do
      stage = stage_fixture()
      assert %Ecto.Changeset{} = Campaigns.change_stage(stage)
    end
  end

  describe "campaigns_members" do
    alias Riso.Campaigns.CampaignMember

    @valid_attrs %{role: "editor"}
    @update_attrs %{role: "viewer"}
    @invalid_attrs %{role: nil}

    def campaign_member_fixture(attrs \\ %{}) do
      {:ok, campaign_member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Campaigns.create_campaign_member()

      campaign_member
    end

    test "create_campaign_member/1 with valid data creates a campaign_member" do
      u = user_fixture()
      c = campaign_fixture()

      assert {:ok, %CampaignMember{} = campaign_member} =
               %{user_id: u.id, campaign_id: c.id}
               |> Enum.into(@valid_attrs)
               |> Campaigns.create_campaign_member()

      assert campaign_member.role == "editor"
    end

    test "create_campaign_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create_campaign_member(@invalid_attrs)
    end

    test "create_campaign_member/1 with custom role returns error changeset" do
      u = user_fixture()
      c = campaign_fixture()

      assert {:error, %Ecto.Changeset{}} = Campaigns.create_campaign_member(%{user_id: u.id, campaign_id: c.id, role: "custom"})
    end

    test "update_campaign_member/2 with valid data updates the campaign_member" do
      u = user_fixture()
      c = campaign_fixture()
      campaign_member = campaign_member_fixture(%{user_id: u.id, campaign_id: c.id})

      assert {:ok, campaign_member} = Campaigns.update_campaign_member(campaign_member, @update_attrs)
      assert %CampaignMember{} = campaign_member
      assert campaign_member.role == "viewer"
    end

    test "update_campaign_member/2 with invalid data returns error changeset" do
      u = user_fixture()
      c = campaign_fixture()
      campaign_member = campaign_member_fixture(%{user_id: u.id, campaign_id: c.id})
      before_update_campaign_member = Campaigns.get_campaign_member!(campaign_member.id)

      assert {:error, %Ecto.Changeset{}} = Campaigns.update_campaign_member(campaign_member, @invalid_attrs)
      assert before_update_campaign_member == Campaigns.get_campaign_member!(campaign_member.id)
    end

    test "update_campaign_member/2 with custom role returns error changeset" do
      u = user_fixture()
      c = campaign_fixture()
      campaign_member = campaign_member_fixture(%{user_id: u.id, campaign_id: c.id})
      before_update_campaign_member = Campaigns.get_campaign_member!(campaign_member.id)

      assert {:error, %Ecto.Changeset{}} = Campaigns.update_campaign_member(campaign_member, %{role: "custom"})
      assert before_update_campaign_member == Campaigns.get_campaign_member!(campaign_member.id)
    end

    test "delete_campaign_member/1 deletes the campaign_member" do
      u = user_fixture()
      c = campaign_fixture()
      campaign_member = campaign_member_fixture(%{user_id: u.id, campaign_id: c.id})
      assert {:ok, %CampaignMember{}} = Campaigns.delete_campaign_member(campaign_member)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get_campaign_member!(campaign_member.id) end
    end
  end
end
