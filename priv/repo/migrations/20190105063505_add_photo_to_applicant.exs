defmodule Riso.Repo.Migrations.AddPhotoToApplicant do
  use Ecto.Migration

  def change do
    alter table(:applicants) do
      add(:photo, :string)
    end
  end
end
