defmodule RisoWeb.Queries.CampaignsQueries do
  use Absinthe.Schema.Notation

  import Ecto.Query, warn: false

  alias Riso.Repo
  alias Riso.Campaigns
  alias Riso.Campaigns.Campaign

  object :campaigns_queries do
    @desc "get campaigns list"
    field :campaigns, list_of(:campaign) do
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        campaigns =
          Campaign
          |> Campaigns.search(args[:keywords])
          |> order_by(desc: :inserted_at)
          |> Repo.paginate(args[:offset])
          |> Repo.all()

        {:ok, campaigns}
      end)
    end

    @desc "Number of campaigns"
    field :campaigns_count, :integer do
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        campaigns_count =
          Campaign
          |> Campaigns.search(args[:keywords])
          |> Repo.count()

        {:ok, campaigns_count}
      end)
    end

    @desc "fetch a campaign by id"
    field :campaign, :campaign do
      arg(:id, non_null(:id))

      resolve(fn args, _ ->
        campaign = Campaign |> Repo.get!(args[:id])
        {:ok, campaign}
      end)
    end

    @desc "Campaign options for a field"
    field :campaign_options, list_of(:option) do
      arg(:field, non_null(:string))

      resolve(fn args, _ ->
        field = String.to_existing_atom(args[:field])

        options =
          Enum.map(Campaign.options()[field], fn opt ->
            %{label: opt, value: opt}
          end)

        {:ok, options}
      end)
    end
  end
end
