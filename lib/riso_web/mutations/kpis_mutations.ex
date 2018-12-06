defmodule RisoWeb.Mutations.KpisMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import RisoWeb.Helpers.ValidationMessageHelpers

  alias RisoWeb.Schema.Middleware
  alias Riso.Kpis

  input_object :kpi_input do
    field(:title, :string)
  end

  object :kpis_mutations do
    @desc "Create an kpi"
    field :create_kpi, :kpi_payload do
      arg(:input, :kpi_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params}, _ ->
        with {:ok, kpi} <- Kpis.create_kpi(params) do
          {:ok, kpi}
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
