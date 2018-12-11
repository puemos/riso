defmodule Riso.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Riso.Repo

  alias Riso.Organizations.Organization

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  def list_organizations do
    Repo.all(Organization)
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the Organization does not exist.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

      iex> get_organization!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organization!(id), do: Repo.get!(Organization, id)

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{source: %Organization{}}

  """
  def change_organization(%Organization{} = organization) do
    Organization.changeset(organization, %{})
  end

  alias Riso.Organizations.OrganizationUser

  @doc """
  Returns the list of organizations_users.

  ## Examples

      iex> list_organizations_users()
      [%OrganizationUser{}, ...]

  """
  def list_organizations_users do
    Repo.all(OrganizationUser)
  end

  @doc """
  Gets a single organization_user.

  Raises `Ecto.NoResultsError` if the Organization user does not exist.

  ## Examples

      iex> get_organization_user!(123)
      %OrganizationUser{}

      iex> get_organization_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organization_user!(id), do: Repo.get!(OrganizationUser, id)

  @doc """
  Creates a organization_user.

  ## Examples

      iex> create_organization_user(%{field: value})
      {:ok, %OrganizationUser{}}

      iex> create_organization_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization_user(attrs \\ %{}) do
    %OrganizationUser{}
    |> OrganizationUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization_user.

  ## Examples

      iex> update_organization_user(organization_user, %{field: new_value})
      {:ok, %OrganizationUser{}}

      iex> update_organization_user(organization_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization_user(%OrganizationUser{} = organization_user, attrs) do
    organization_user
    |> OrganizationUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OrganizationUser.

  ## Examples

      iex> delete_organization_user(organization_user)
      {:ok, %OrganizationUser{}}

      iex> delete_organization_user(organization_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization_user(%OrganizationUser{} = organization_user) do
    Repo.delete(organization_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization_user changes.

  ## Examples

      iex> change_organization_user(organization_user)
      %Ecto.Changeset{source: %OrganizationUser{}}

  """
  def change_organization_user(%OrganizationUser{} = organization_user) do
    OrganizationUser.changeset(organization_user, %{})
  end
end
