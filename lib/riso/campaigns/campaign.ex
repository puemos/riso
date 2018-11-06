defmodule Riso.Campaigns.Campaign do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Accounts.User
  alias Riso.Campaigns.{CampaignUser, Stage}

  @options %{}
  @default_values %{}

  schema "campaigns" do
    field :title, :string

    has_many :stages, Stage

    many_to_many :users, User, join_through: CampaignUser

    timestamps()
  end

  def options(), do: @options
  def default_values(), do: @default_values

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
