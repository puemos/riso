defmodule Riso.Campaigns do
  import Ecto.Query, warn: false
  alias Riso.Repo
  alias Riso.Campaigns.{Campaign}
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

  def create(users, attrs \\ %{}) do
    %Campaign{}
    |> Campaign.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:users, users)
    |> Repo.insert()
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
      {:error, "not authorise"}
    end
  end
end
