defmodule Riso.Applicants do
  @moduledoc """
  The Applicants context.
  """

  import Ecto.Query, warn: false
  alias Riso.Repo
  alias Riso.Accounts.{User}
  alias Riso.Applicants.{Applicant, ApplicantReview}
  alias Riso.Positions.{Position, PositionStage}

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

  def set_position_stage(%Applicant{} = applicant, %PositionStage{} = position_stage) do
    applicant
    |> update_applicant(%{position_stage_id: position_stage.id})
  end

  def set_position(%Applicant{} = applicant, %Position{} = position) do
    applicant
    |> update_applicant(%{position_id: position.id})
  end

  def list_applicants_reviews do
    Repo.all(ApplicantReview)
  end

  def get_applicant_review(id), do: Repo.get(ApplicantReview, id)

  def create_applicant_review(attrs \\ %{}) do
    %ApplicantReview{}
    |> ApplicantReview.changeset(attrs)
    |> Repo.insert()
  end

  def update_applicant_review(%ApplicantReview{} = applicant_review, attrs) do
    applicant_review
    |> ApplicantReview.changeset(attrs)
    |> Repo.update()
  end

  def delete_applicant_review(%ApplicantReview{} = applicant_review) do
    Repo.delete(applicant_review)
  end

  def change_applicant_review(%ApplicantReview{} = applicant_review) do
    ApplicantReview.changeset(applicant_review, %{})
  end

  def set_reviewer(%ApplicantReview{} = applicant_review, %User{} = user) do
    applicant_review
    |> update_applicant_review(%{applicant_review: user.id})
  end
end
