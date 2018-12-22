defmodule Riso.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Riso.Repo

  alias Riso.Organizations.Organization
  alias Riso.Organizations.OrganizationMember
  alias Riso.Accounts.User

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end

  def search(query, nil), do: query

  def search(query, keywords) do
    from(
      p in query,
      where: ilike(p.title, ^"%#{keywords}%")
    )
  end

  def list_organizations do
    Repo.all(Organization)
  end

  def list_organizations_by_user(%User{} = user) do
    Organization
    |> join(:left, [p], m in assoc(p, :members))
    |> where([p, m], m.user_id == ^user.id)
  end

  def get_organization(id), do: Repo.get(Organization, id)

  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  def change_organization(%Organization{} = organization) do
    Organization.changeset(organization, %{})
  end

  def list_organizations_users do
    Repo.all(OrganizationMember)
  end

  def get_organization_member(id), do: Repo.get(OrganizationMember, id)

  def create_organization_member(attrs \\ %{}) do
    %OrganizationMember{}
    |> OrganizationMember.changeset(attrs)
    |> Repo.insert()
  end

  def update_organization_member(%OrganizationMember{} = organization_member, attrs) do
    organization_member
    |> OrganizationMember.changeset(attrs)
    |> Repo.update()
  end

  def delete_organization_member(%OrganizationMember{} = organization_member) do
    Repo.delete(organization_member)
  end

  def change_organization_member(%OrganizationMember{} = organization_member) do
    OrganizationMember.changeset(organization_member, %{})
  end

  def can_view?(%Organization{} = organization, %User{} = user) do
    roles = get_member_roles(user, organization)
    Enum.member?(roles, "viewer") or Enum.member?(roles, "editor")
  end

  def can_edit?(%Organization{} = organization, %User{} = user) do
    roles = get_member_roles(user, organization)
    Enum.member?(roles, "editor")
  end

  def add_member(%Organization{} = organization, %User{} = user, role \\ "viewer") do
    create_organization_member(%{role: role, user_id: user.id, organization_id: organization.id})
  end

  defp get_member_roles(%User{} = user, %Organization{} = organization) do
    from(
      cm in OrganizationMember,
      where: cm.organization_id == ^organization.id and cm.user_id == ^user.id
    )
    |> Repo.all()
    |> Enum.map(fn m -> m.role end)
  end
end
