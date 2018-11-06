defmodule RisoWeb.Mutations.CampaignsMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import RisoWeb.Helpers.ValidationMessageHelpers

  alias RisoWeb.Schema.Middleware
  alias Riso.Repo
  alias Riso.Campaigns
  alias Riso.Campaigns.Campaign

  input_object :campaign_input do
    field(:title, :string)
  end

  object :campaigns_mutations do
    @desc "Create a campaign"
    field :create_campaign, :campaign_payload do
      arg(:input, :campaign_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params}, %{context: context} ->
        case context[:current_user] |> Campaigns.create(params) do
          {:ok, campaign} -> {:ok, campaign}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        end
      end)
    end

    @desc "Update a Campaign and return Campaign"
    field :update_campaign, :campaign_payload do
      arg(:id, non_null(:id))
      arg(:input, :campaign_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params} = args, %{context: context} ->
        campaign =
          Campaign
          |> preload(:author)
          |> Repo.get!(args[:id])

        with true <- Campaigns.is_user(context[:current_user], campaign),
             {:ok, campaign_updated} <- Campaigns.update(campaign, params) do
          {:ok, campaign_updated}
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          {:error, msg} -> {:ok, generic_message(msg)}
        end
      end)
    end

    @desc "Destroy a Campaign"
    field :delete_campaign, :campaign_payload do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        campaign =
          Campaign
          |> preload(:author)
          |> Repo.get!(args[:id])

        case Campaigns.is_user(context[:current_user], campaign) do
          true -> campaign |> Campaigns.delete()
          {:error, msg} -> {:ok, generic_message(msg)}
        end
      end)
    end

    @desc "Create a stage to campaign"
    field :create_stage, :stage_payload do
      arg(:title, :string)
      arg(:campaign_id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        campaign =
          Campaign
          |> preload(:author)
          |> Repo.get!(args[:campaign_id])

        case Campaigns.is_user(context[:current_user], campaign) do
          true ->
            case Campaigns.create_stage(campaign, %{title: args[:title]}) do
              {:ok, stage} -> {:ok, stage}
              {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
            end

          {:error, msg} ->
            {:ok, generic_message(msg)}
        end
      end)
    end
  end
end
