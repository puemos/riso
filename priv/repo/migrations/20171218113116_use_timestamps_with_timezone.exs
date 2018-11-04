defmodule Riso.Repo.Migrations.UseTimestampsWithTimezone do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :inserted_at, :timestamptz
      modify :updated_at, :timestamptz
    end
  end
end
