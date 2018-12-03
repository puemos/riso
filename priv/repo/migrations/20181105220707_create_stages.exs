defmodule Riso.Repo.Migrations.CreateStages do
  use Ecto.Migration

  def change do
    create table(:stages) do
      add :title, :string
      add :campaign_id, references(:campaigns, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:stages, [:campaign_id])
  end
end
