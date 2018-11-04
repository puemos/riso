defmodule Riso.Campaigns.Campaign do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Accounts.User
  alias Riso.Campaigns.CampaignUser

  schema "campaigns" do
    field :name, :string

    many_to_many :users, User, join_through: CampaignUser

    timestamps()
  end

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
