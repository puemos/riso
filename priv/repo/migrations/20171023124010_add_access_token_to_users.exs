defmodule Riso.Repo.Migrations.AddAccessTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :access_token, :string
    end
  end
end
