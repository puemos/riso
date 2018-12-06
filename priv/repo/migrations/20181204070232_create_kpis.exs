defmodule Riso.Repo.Migrations.CreateKpis do
  use Ecto.Migration

  def change do
    create table(:kpis) do
      add :title, :string

      timestamps(type: :utc_datetime)
    end

  end
end
