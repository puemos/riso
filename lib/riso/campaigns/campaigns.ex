defmodule Riso.Campaigns do
  import Ecto.Query, warn: false
  alias Riso.Repo
  alias Riso.Campaigns.{Campaign, CampaignMember, Stage}
  alias Riso.Accounts.{User}

  def search(query, nil), do: query

  def search(query, keywords) do
    from(
      r in query,
      where: ilike(r.title, ^"%#{keywords}%")
    )
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end

  def get!(id) do
    Campaign
    |> Repo.get!(id)
  end

  def create(user, attrs \\ %{}) do
    with {:ok, campaign} <-
           %Campaign{}
           |> Campaign.changeset(attrs)
           |> Repo.insert() do
      add_member(campaign, user, "editor")
      {:ok, campaign}
    else
      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
      _ -> {:error, "Ops, error"}
    end
  end

  def update(%Campaign{} = campaign, attrs) do
    campaign
    |> Campaign.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Campaign{} = campaign) do
    Repo.delete(campaign)
  end

  def change(%Campaign{} = campaign) do
    Campaign.changeset(campaign, %{})
  end

  @spec can(Atom.t(), User.t(), Campaign.t()) :: boolean
  def can(:view, %User{} = user, %Campaign{} = campaign) do
    roles = get_member_roles(user, campaign)
    Enum.member?(roles, "viewer") or Enum.member?(roles, "editor")
  end

  @spec can(Atom.t(), User.t(), Campaign.t()) :: boolean
  def can(:edit, %User{} = user, %Campaign{} = campaign) do
    roles = get_member_roles(user, campaign)
    IO.inspect(roles)
    Enum.member?(roles, "editor")
  end

  @spec add_member(Campaign.t(), User.t(), String.t()) :: CampaignMember.t() | {:error, String.t()}
  def add_member(campaign, user, role \\ "viewer") do
    create_campaign_member(%{role: role, user_id: user.id, campaign_id: campaign.id})
  end

  def get_stage!(id), do: Repo.get!(Stage, id)

  def create_stage(campaign, attrs \\ %{}) do
    %Stage{}
    |> Stage.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:campaign, campaign)
    |> Repo.insert()
  end

  def update_stage(%Stage{} = stage, attrs) do
    stage
    |> Stage.changeset(attrs)
    |> Repo.update()
  end

  def delete_stage(%Stage{} = stage) do
    Repo.delete(stage)
  end

  def change_stage(%Stage{} = stage) do
    Stage.changeset(stage, %{})
  end

  @spec get_member_roles(User.t(), Campaign.t()) :: list(String.t()) | {:error, String.t()}
  defp get_member_roles(%User{} = user, %Campaign{} = campaign) do
    from(
      cm in CampaignMember,
      where: cm.campaign_id == ^campaign.id and cm.user_id == ^user.id
    )
    |> Repo.all()
    |> Enum.map(fn m -> m.role end)
  end

  def get_campaign_member!(id), do: Repo.get!(CampaignMember, id)


  def create_campaign_member(attrs \\ %{}) do
    %CampaignMember{}
    |> CampaignMember.changeset(attrs)
    |> Repo.insert()
  end

  def update_campaign_member(%CampaignMember{} = campaign_member, attrs) do
    campaign_member
    |> CampaignMember.changeset(attrs)
    |> Repo.update()
  end

  def delete_campaign_member(%CampaignMember{} = campaign_member) do
    Repo.delete(campaign_member)
  end
end
