defmodule Riso.Campaigns.Campaign do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Campaigns.{CampaignMember, Stage}

  @options %{}
  @default_values %{}

  schema "campaigns" do
    field :title, :string

    has_many :stages, Stage

    has_many :members, CampaignMember

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
