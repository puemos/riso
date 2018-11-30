defmodule Riso.Positions do
  import Ecto.Query, warn: false
  alias Riso.Repo
  alias Riso.Positions.{Position, PositionMember, PositionStage, PositionKpi}
  alias Riso.Accounts.{User}

  def search(query, nil), do: query

  def search(query, user_id, keywords) do
    from(
      p in query,
      join: m in assoc(p, :members),
      where: ilike(p.title, ^"%#{keywords}%") and m.user_id == ^user_id
    )
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end

  def can_view?(%Position{} = position, %User{} = user) do
    roles = get_member_roles(user, position)
    Enum.member?(roles, "viewer") or Enum.member?(roles, "editor")
  end

  def can_view_resource?(resource, %User{} = user) do
    try do
      get_position(resource.position_id)
      |> can_view?(user)
    rescue
      _ -> false
    end
  end

  def can_edit?(%Position{} = position, %User{} = user) do
    roles = get_member_roles(user, position)
    Enum.member?(roles, "editor")
  end

  def can_edit_resource?(resource, %User{} = user) do
    try do
      get_position(resource.position_id)
      |> can_edit?(user)
    rescue
      _ -> false
    end
  end

  def get_position(id) do
    Position
    |> Repo.get(id)
  end

  def create_position(attrs \\ %{}) do
    %Position{}
    |> Position.changeset(attrs)
    |> Repo.insert()
  end

  def update_position(%Position{} = position, attrs) do
    position
    |> Position.changeset(attrs)
    |> Repo.update()
  end

  def delete_position(%Position{} = position) do
    Repo.delete(position)
  end

  def change_position(%Position{} = position) do
    Position.changeset(position, %{})
  end

  def get_position_stage(id), do: Repo.get(PositionStage, id)

  def create_position_stage(attrs \\ %{}) do
    %PositionStage{}
    |> PositionStage.changeset(attrs)
    |> Repo.insert()
  end

  def update_position_stage(%PositionStage{} = position_stage, attrs) do
    position_stage
    |> PositionStage.changeset(attrs)
    |> Repo.update()
  end

  def delete_position_stage(%PositionStage{} = position_stage) do
    Repo.delete(position_stage)
  end

  def change_position_stage(%PositionStage{} = position_stage) do
    PositionStage.changeset(position_stage, %{})
  end

  def add_member(%Position{} = position, %User{} = user, role \\ "viewer") do
    create_position_member(%{role: role, user_id: user.id, position_id: position.id})
  end

  defp get_member_roles(%User{} = user, %Position{} = position) do
    from(
      cm in PositionMember,
      where: cm.position_id == ^position.id and cm.user_id == ^user.id
    )
    |> Repo.all()
    |> Enum.map(fn m -> m.role end)
  end

  def get_position_member(id), do: Repo.get(PositionMember, id)

  def create_position_member(attrs \\ %{}) do
    %PositionMember{}
    |> PositionMember.changeset(attrs)
    |> Repo.insert()
  end

  def update_position_member(%PositionMember{} = position_member, attrs) do
    position_member
    |> PositionMember.changeset(attrs)
    |> Repo.update()
  end

  def delete_position_member(%PositionMember{} = position_member) do
    Repo.delete(position_member)
  end

  def list_positions_kpis(position) do
    from(
      cm in PositionKpi,
      where: cm.position_id == ^position.id
    )
    |> Repo.all()
  end

  def get_position_kpi(id), do: Repo.get(PositionKpi, id)

  def create_position_kpi(attrs \\ %{}) do
    %PositionKpi{}
    |> PositionKpi.changeset(attrs)
    |> Repo.insert()
  end

  def update_position_kpi(%PositionKpi{} = position_kpi, attrs) do
    position_kpi
    |> PositionKpi.changeset(attrs)
    |> Repo.update()
  end

  def delete_position_kpi(%PositionKpi{} = position_kpi) do
    Repo.delete(position_kpi)
  end

  def change_position_kpi(%PositionKpi{} = position_kpi) do
    PositionKpi.changeset(position_kpi, %{})
  end
end
