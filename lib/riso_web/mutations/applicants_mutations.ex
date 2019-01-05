defmodule RisoWeb.Mutations.ApplicantsMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import RisoWeb.Helpers.ValidationMessageHelpers

  alias RisoWeb.Schema.Middleware
  alias Riso.Applicants
  alias Riso.Positions

  input_object :applicant_input do
    field(:name, non_null(:string))
    field(:position_id, non_null(:id))
  end

  input_object :applicant_review_input do
    field(:score, non_null(:integer))
    field(:kpi_id, non_null(:id))
    field(:position_id, non_null(:id))
    field(:applicant_id, non_null(:id))
  end

  object :applicants_mutations do
    @desc "Create an applicant"
    field :create_applicant, :applicant_payload do
      arg(:input, :applicant_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params}, _ ->
        with {:ok, applicant} <- Applicants.create_applicant(params) do
          {:ok, applicant}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}
        end
      end)
    end

    @desc "Add an applicant review for a KPI"
    field :add_applicant_review, :applicant_payload do
      arg(:input, :applicant_review_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params}, %{context: context} ->
        reviewer = context[:current_user]

        review_params =
          Map.merge(params, %{
            reviewer_id: reviewer.id
          })

        with position when not is_nil(position) <- Positions.get_position(params[:position_id]),
             true <- Positions.can_edit?(position, reviewer),
             {:ok, applicant_review} <- Applicants.create_applicant_review(review_params) do
          {:ok, applicant_review}
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

    @desc "Change applicant position stage"
    field :change_applicant_stage, :applicant_payload do
      arg(:position_stage_id, :id)
      arg(:applicant_id, :id)
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        with applicant when not is_nil(applicant) <-
               Applicants.get_applicant(args[:applicant_id]),
             position_stage when not is_nil(position_stage) <-
               Positions.get_position_stage(args[:position_stage_id]),
             true <- Positions.can_edit_resource?(position_stage, context[:current_user]),
             {:ok, applicant} <- Applicants.set_position_stage(applicant, position_stage) do
          {:ok, applicant}
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
  end
end
