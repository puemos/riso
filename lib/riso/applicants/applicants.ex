defmodule Riso.Applicants do
  @moduledoc """
  The Applicants context.
  """

  import Ecto.Query, warn: false
  alias Riso.Repo
  alias Riso.Applicants.Applicant

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end

  def list_applicants do
    Repo.all(Applicant)
  end

  def get_applicant(id), do: Repo.get(Applicant, id)

  def create_applicant(attrs \\ %{}) do
    %Applicant{}
    |> Applicant.changeset(attrs)
    |> Repo.insert()
  end

  def update_applicant(%Applicant{} = applicant, attrs) do
    applicant
    |> Applicant.changeset(attrs)
    |> Repo.update()
  end

  def delete_applicant(%Applicant{} = applicant) do
    Repo.delete(applicant)
  end

  def change_applicant(%Applicant{} = applicant) do
    Applicant.changeset(applicant, %{})
  end
end
