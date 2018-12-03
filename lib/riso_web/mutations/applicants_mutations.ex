defmodule RisoWeb.Mutations.ApplicantsMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import RisoWeb.Helpers.ValidationMessageHelpers

  alias RisoWeb.Schema.Middleware
  alias Riso.Applicants

  input_object :applicant_input do
    field(:name, :string)
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
  end
end
