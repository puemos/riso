defmodule RisoWeb.Queries.OrganizationsQueries do
  use Absinthe.Schema.Notation

  import Ecto.Query, warn: false

  alias RisoWeb.Schema.Middleware
  alias Riso.Repo
  alias Riso.Organizations

  object :organizations_queries do
    @desc "get current user organizations list"
    field :organizations, list_of(:organization) do
      middleware(Middleware.Authorize)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, %{context: context} ->
        user = context[:current_user]

        organizations =
          Organizations.list_organizations_by_user(user)
          |> Organizations.search(args[:keywords])
          |> order_by(desc: :inserted_at)
          |> Repo.paginate(args[:offset])
          |> Repo.all()

        {:ok, organizations}
      end)
    end

    @desc "fetch a organization by id"
    field :organization, :organization do
      middleware(Middleware.Authorize)
      arg(:id, non_null(:id))

      resolve(fn args, %{context: context} ->
        user = context[:current_user]

        with(
          organization when not is_nil(organization) <- Organizations.get_organization(args[:id]),
          true <- Organizations.can_view?(organization, user)
        ) do
          {:ok, organization}
        else
          nil ->
            {:error, "Not found"}

          false ->
            {:error, "Unauthorize"}
        end
      end)
    end
  end
end
