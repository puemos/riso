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

  def list do
    Repo.all(Campaign)
  end

  def create(user, attrs \\ %{}) do
    with {:ok, campaign} <-
           %Campaign{}
           |> Campaign.changeset(attrs)
           |> Repo.insert() do
      add_member(campaign, user, "editor")
      {:ok, campaign}
    else
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
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

  @spec is_user(User.t(), Campaign.t()) :: true | {:error, String.t()}
  def is_user(%User{} = user, %Campaign{} = campaign) do
    if Enum.any?(campaign.users, fn campaign_user -> campaign_user == user.id end) do
      true
    else
      {:error, "not authorize"}
    end
  end

  @spec add_member(Campaign.t(), User.t(), String.t()) :: CampaignMember.t() | {:error, String.t()}
  def add_member(campaign, user, role) do
    %CampaignMember{}
    |> CampaignMember.changeset(%{role: role, user_id: user.id, campaign_id: campaign.id})
    |> Repo.insert()
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

  alias Riso.Campaigns.CampaignMember

  @doc """
  Returns the list of campaigns_members.

  ## Examples

      iex> list_campaigns_members()
      [%CampaignMember{}, ...]

  """
  def list_campaigns_members do
    Repo.all(CampaignMember)
  end

  @doc """
  Gets a single campaign_member.

  Raises `Ecto.NoResultsError` if the Campaign member does not exist.

  ## Examples

      iex> get_campaign_member!(123)
      %CampaignMember{}

      iex> get_campaign_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_campaign_member!(id), do: Repo.get!(CampaignMember, id)

  @doc """
  Creates a campaign_member.

  ## Examples

      iex> create_campaign_member(%{field: value})
      {:ok, %CampaignMember{}}

      iex> create_campaign_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_campaign_member(attrs \\ %{}) do
    %CampaignMember{}
    |> CampaignMember.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a campaign_member.

  ## Examples

      iex> update_campaign_member(campaign_member, %{field: new_value})
      {:ok, %CampaignMember{}}

      iex> update_campaign_member(campaign_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_campaign_member(%CampaignMember{} = campaign_member, attrs) do
    campaign_member
    |> CampaignMember.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CampaignMember.

  ## Examples

      iex> delete_campaign_member(campaign_member)
      {:ok, %CampaignMember{}}

      iex> delete_campaign_member(campaign_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_campaign_member(%CampaignMember{} = campaign_member) do
    Repo.delete(campaign_member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking campaign_member changes.

  ## Examples

      iex> change_campaign_member(campaign_member)
      %Ecto.Changeset{source: %CampaignMember{}}

  """
  def change_campaign_member(%CampaignMember{} = campaign_member) do
    CampaignMember.changeset(campaign_member, %{})
  end
end
