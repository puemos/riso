defmodule Riso.Campaigns.CampaignMember do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Campaigns.Campaign
  alias Riso.Accounts.User

  @options %{
    role: ["viewer", "editor"]
  }
  @default_values %{
    role: "viewer"
  }

  @primary_key false
  schema "campaigns_members" do
    field :role, :string

    belongs_to :user, User
    belongs_to :campaign, Campaign

    timestamps()
  end

  def options(), do: @options
  def default_values(), do: @default_values

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :campaign_id, :role])
    |> validate_inclusion(:role, @options[:role])
    |> validate_required([:user_id, :campaign_id])
  end
end
