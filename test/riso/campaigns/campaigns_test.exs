defmodule Riso.CampaignsTest do
  use Riso.DataCase

  alias Riso.Campaigns

  describe "campaigns" do
    alias Riso.Campaigns.Campaign

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def campaign_fixture(attrs \\ %{}) do
      {:ok, campaign} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Campaigns.create_campaign()

      campaign
    end

    test "list_campaigns/0 returns all campaigns" do
      campaign = campaign_fixture()
      assert Campaigns.list_campaigns() == [campaign]
    end

    test "get_campaign!/1 returns the campaign with given id" do
      campaign = campaign_fixture()
      assert Campaigns.get_campaign!(campaign.id) == campaign
    end

    test "create_campaign/1 with valid data creates a campaign" do
      assert {:ok, %Campaign{} = campaign} = Campaigns.create_campaign(@valid_attrs)
      assert campaign.name == "some name"
    end

    test "create_campaign/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create_campaign(@invalid_attrs)
    end

    test "update_campaign/2 with valid data updates the campaign" do
      campaign = campaign_fixture()
      assert {:ok, campaign} = Campaigns.update_campaign(campaign, @update_attrs)
      assert %Campaign{} = campaign
      assert campaign.name == "some updated name"
    end

    test "update_campaign/2 with invalid data returns error changeset" do
      campaign = campaign_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaigns.update_campaign(campaign, @invalid_attrs)
      assert campaign == Campaigns.get_campaign!(campaign.id)
    end

    test "delete_campaign/1 deletes the campaign" do
      campaign = campaign_fixture()
      assert {:ok, %Campaign{}} = Campaigns.delete_campaign(campaign)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get_campaign!(campaign.id) end
    end

    test "change_campaign/1 returns a campaign changeset" do
      campaign = campaign_fixture()
      assert %Ecto.Changeset{} = Campaigns.change_campaign(campaign)
    end
  end

  describe "campaigns_users" do
    alias Riso.Campaigns.CampaignUser

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def campaign_user_fixture(attrs \\ %{}) do
      {:ok, campaign_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Campaigns.create_campaign_user()

      campaign_user
    end

    test "list_campaigns_users/0 returns all campaigns_users" do
      campaign_user = campaign_user_fixture()
      assert Campaigns.list_campaigns_users() == [campaign_user]
    end

    test "get_campaign_user!/1 returns the campaign_user with given id" do
      campaign_user = campaign_user_fixture()
      assert Campaigns.get_campaign_user!(campaign_user.id) == campaign_user
    end

    test "create_campaign_user/1 with valid data creates a campaign_user" do
      assert {:ok, %CampaignUser{} = campaign_user} = Campaigns.create_campaign_user(@valid_attrs)
    end

    test "create_campaign_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create_campaign_user(@invalid_attrs)
    end

    test "update_campaign_user/2 with valid data updates the campaign_user" do
      campaign_user = campaign_user_fixture()
      assert {:ok, campaign_user} = Campaigns.update_campaign_user(campaign_user, @update_attrs)
      assert %CampaignUser{} = campaign_user
    end

    test "update_campaign_user/2 with invalid data returns error changeset" do
      campaign_user = campaign_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaigns.update_campaign_user(campaign_user, @invalid_attrs)
      assert campaign_user == Campaigns.get_campaign_user!(campaign_user.id)
    end

    test "delete_campaign_user/1 deletes the campaign_user" do
      campaign_user = campaign_user_fixture()
      assert {:ok, %CampaignUser{}} = Campaigns.delete_campaign_user(campaign_user)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get_campaign_user!(campaign_user.id) end
    end

    test "change_campaign_user/1 returns a campaign_user changeset" do
      campaign_user = campaign_user_fixture()
      assert %Ecto.Changeset{} = Campaigns.change_campaign_user(campaign_user)
    end
  end
end
