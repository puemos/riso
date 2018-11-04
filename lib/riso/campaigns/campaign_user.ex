defmodule Riso.Campaigns.CampaignUser do
  use Ecto.Schema
  alias Riso.Campaigns.Campaign
  alias Riso.Accounts.User

  @primary_key false
  schema "campaigns_users" do
    belongs_to :user, User
    belongs_to :campaign, Campaign
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:user_id, :campaign_id])
    |> Ecto.Changeset.validate_required([:user_id, :campaign_id])
  end
end
