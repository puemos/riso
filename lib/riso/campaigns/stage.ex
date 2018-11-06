defmodule Riso.Campaigns.Stage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Campaigns.Campaign

  schema "stages" do
    field :title, :string
    belongs_to :campaign, Campaign

    timestamps()
  end

  @doc false
  def changeset(stage, attrs) do
    stage
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
