defmodule Riso.Repo.Migrations.AddConfirmationFieldsToUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :confirmation_code, :string
      add :confirmed_at, :naive_datetime
      add :confirmation_sent_at, :naive_datetime
    end
  end

  def down do
    alter table(:users) do
      remove :confirmation_code
      remove :confirmed_at
      remove :confirmation_sent_at
    end
  end
end
