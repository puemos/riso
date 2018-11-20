defmodule Riso.Positions do
  import Ecto.Query, warn: false
  alias Riso.Repo
  alias Riso.Positions.{Position, PositionMember, PositionStage}
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
    Position
    |> Repo.get!(id)
  end

  def create(user, attrs \\ %{}) do
    with {:ok, position} <-
           %Position{}
           |> Position.changeset(attrs)
           |> Repo.insert() do
      add_member(position, user, "editor")
      {:ok, position}
    else
      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
      _ -> {:error, "Ops, error"}
    end
  end

  def update(%Position{} = position, attrs) do
    position
    |> Position.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Position{} = position) do
    Repo.delete(position)
  end

  def change(%Position{} = position) do
    Position.changeset(position, %{})
  end

  @spec can(Atom.t(), User.t(), Position.t()) :: boolean
  def can(:view, %User{} = user, %Position{} = position) do
    roles = get_member_roles(user, position)
    Enum.member?(roles, "viewer") or Enum.member?(roles, "editor")
  end

  @spec can(Atom.t(), User.t(), Position.t()) :: boolean
  def can(:edit, %User{} = user, %Position{} = position) do
    roles = get_member_roles(user, position)
    IO.inspect(roles)
    Enum.member?(roles, "editor")
  end

  @spec add_member(Position.t(), User.t(), String.t()) :: PositionMember.t() | {:error, String.t()}
  def add_member(position, user, role \\ "viewer") do
    create_position_member(%{role: role, user_id: user.id, position_id: position.id})
  end

  def get_position_stage!(id), do: Repo.get!(PositionStage, id)

  def create_position_stage(position, attrs \\ %{}) do
    %PositionStage{}
    |> PositionStage.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:position, position)
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

  @spec get_member_roles(User.t(), Position.t()) :: list(String.t()) | {:error, String.t()}
  defp get_member_roles(%User{} = user, %Position{} = position) do
    from(
      cm in PositionMember,
      where: cm.position_id == ^position.id and cm.user_id == ^user.id
    )
    |> Repo.all()
    |> Enum.map(fn m -> m.role end)
  end

  def get_position_member!(id), do: Repo.get!(PositionMember, id)


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
end
