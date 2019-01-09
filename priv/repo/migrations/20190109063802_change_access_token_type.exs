defmodule Riso.Repo.Migrations.ChangeAccessTokenType do
  use Ecto.Migration

  def change do
    alter table(:users  ) do
      modify(:access_token, :string, size: 1024)
    end
  end
end
