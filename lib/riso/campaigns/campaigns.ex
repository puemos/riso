defmodule Riso.Campaigns do
  @moduledoc """
  The Campaigns context.
  """

  import Ecto.Query, warn: false
  alias Riso.Repo

  alias Riso.Campaigns.{Campaign, CampaignUser}

  def list_campaigns do
    Repo.all(Campaign)
  end

  def get_campaign!(id), do: Repo.get!(Campaign, id)

  def create_campaign(attrs \\ %{}) do
    %Campaign{}
    |> Campaign.changeset(attrs)
    |> Repo.insert()
  end

  def update_campaign(%Campaign{} = campaign, attrs) do
    campaign
    |> Campaign.changeset(attrs)
    |> Repo.update()
  end

  def delete_campaign(%Campaign{} = campaign) do
    Repo.delete(campaign)
  end

  def change_campaign(%Campaign{} = campaign) do
    Campaign.changeset(campaign, %{})
  end

  def list_campaigns_users do
    Repo.all(CampaignUser)
  end

  def get_campaign_user!(id), do: Repo.get!(CampaignUser, id)

  def create_campaign_user(attrs \\ %{}) do
    %CampaignUser{}
    |> CampaignUser.changeset(attrs)
    |> Repo.insert()
  end

  def update_campaign_user(%CampaignUser{} = campaign_user, attrs) do
    campaign_user
    |> CampaignUser.changeset(attrs)
    |> Repo.update()
  end

  def delete_campaign_user(%CampaignUser{} = campaign_user) do
    Repo.delete(campaign_user)
  end

  def change_campaign_user(%CampaignUser{} = campaign_user) do
    CampaignUser.changeset(campaign_user, %{})
  end
end
