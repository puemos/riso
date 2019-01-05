defmodule RisoWeb.Queries.ApplicantsQueries do
  use Absinthe.Schema.Notation

  import Ecto.Query, warn: false

  alias RisoWeb.Schema.Middleware
  alias Riso.Applicants
  alias Riso.Positions

  object :applicants_queries do
    @desc "fetch a applicant by id"
    field :applicant, :applicant do
      middleware(Middleware.Authorize)
      arg(:id, non_null(:id))

      resolve(fn args, %{context: context} ->
        user = context[:current_user]

        with applicant when not is_nil(applicant) <- Applicants.get_applicant(args[:id]),
             position when not is_nil(position) <- Positions.get_position(applicant.position_id),
             true <- Positions.can_view?(position, user) do
          {:ok, applicant}
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
