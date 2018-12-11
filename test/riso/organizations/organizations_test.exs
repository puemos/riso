defmodule Riso.OrganizationsTest do
  use Riso.DataCase

  alias Riso.Organizations

  describe "organizations" do
    alias Riso.Organizations.Organization

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def organization_fixture(attrs \\ %{}) do
      {:ok, organization} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Organizations.create_organization()

      organization
    end

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Organizations.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Organizations.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      assert {:ok, %Organization{} = organization} = Organizations.create_organization(@valid_attrs)
      assert organization.name == "some name"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{} = organization} = Organizations.update_organization(organization, @update_attrs)
      assert organization.name == "some updated name"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_organization(organization, @invalid_attrs)
      assert organization == Organizations.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Organizations.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Organizations.change_organization(organization)
    end
  end

  describe "organizations_users" do
    alias Riso.Organizations.OrganizationUser

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def organization_user_fixture(attrs \\ %{}) do
      {:ok, organization_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Organizations.create_organization_user()

      organization_user
    end

    test "list_organizations_users/0 returns all organizations_users" do
      organization_user = organization_user_fixture()
      assert Organizations.list_organizations_users() == [organization_user]
    end

    test "get_organization_user!/1 returns the organization_user with given id" do
      organization_user = organization_user_fixture()
      assert Organizations.get_organization_user!(organization_user.id) == organization_user
    end

    test "create_organization_user/1 with valid data creates a organization_user" do
      assert {:ok, %OrganizationUser{} = organization_user} = Organizations.create_organization_user(@valid_attrs)
    end

    test "create_organization_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization_user(@invalid_attrs)
    end

    test "update_organization_user/2 with valid data updates the organization_user" do
      organization_user = organization_user_fixture()
      assert {:ok, %OrganizationUser{} = organization_user} = Organizations.update_organization_user(organization_user, @update_attrs)
    end

    test "update_organization_user/2 with invalid data returns error changeset" do
      organization_user = organization_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_organization_user(organization_user, @invalid_attrs)
      assert organization_user == Organizations.get_organization_user!(organization_user.id)
    end

    test "delete_organization_user/1 deletes the organization_user" do
      organization_user = organization_user_fixture()
      assert {:ok, %OrganizationUser{}} = Organizations.delete_organization_user(organization_user)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization_user!(organization_user.id) end
    end

    test "change_organization_user/1 returns a organization_user changeset" do
      organization_user = organization_user_fixture()
      assert %Ecto.Changeset{} = Organizations.change_organization_user(organization_user)
    end
  end
end
