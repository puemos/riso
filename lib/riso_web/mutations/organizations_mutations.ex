defmodule RisoWeb.Mutations.OrganizationsMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import RisoWeb.Helpers.ValidationMessageHelpers

  alias RisoWeb.Schema.Middleware
  alias Riso.Organizations

  input_object :organization_input do
    field(:name, :string)
  end

  input_object :organization_member_input do
    field(:role, :organization_memebr_role)
  end

  object :organizations_mutations do
    @desc "Create a organization"
    field :create_organization, :organization_payload do
      arg(:input, :organization_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params}, %{context: context} ->
        with {:ok, organization} <- Organizations.create_organization(params),
             Organizations.add_member(organization, context[:current_user], "editor") do
          {:ok, organization}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}
        end
      end)
    end

    @desc "Update a Organization and return Organization"
    field :update_organization, :organization_payload do
      arg(:id, non_null(:id))
      arg(:input, :organization_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params} = args, %{context: context} ->
        with organization when not is_nil(organization) <-
               Organizations.get_organization(args[:id]),
             true <- Organizations.can_edit?(organization, context[:current_user]),
             {:ok, organization_updated} <-
               Organizations.update_organization(organization, params) do
          {:ok, organization_updated}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end

    @desc "Destroy a Organization"
    field :delete_organization, :organization_payload do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        with organization when not is_nil(organization) <-
               Organizations.get_organization(args[:id]),
             true <- Organizations.can_edit?(organization, context[:current_user]),
             Organizations.delete_organization(organization) do
          {:ok, organization}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end

    @desc "Add a member to a organization"
    field :add_organization_member, :organization_member_payload do
      arg(:input, :organization_member_input)
      arg(:organization_id, non_null(:id))
      arg(:member_email, non_null(:string))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        organization_member_args = args[:input]

        with organization when not is_nil(organization) <-
               Organizations.get_organization(args[:organization_id]),
             {:ok, user} when not is_nil(user) <-
               Riso.Accounts.user_by_email(args[:member_email]),
             true <- Organizations.can_edit?(organization, context[:current_user]),
             {:ok, organization_member} <-
               Organizations.add_member(organization, user, organization_member_args[:role]) do
          {:ok, organization_member}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, %Ecto.Query{}} ->
            {:ok, generic_message("The email #{args[:member_email]} was not found")}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end
  end
end
