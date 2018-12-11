defmodule Riso.Repo.Migrations.CreateOrganizationsUsers do
  use Ecto.Migration

  def change do
    create table(:organizations_users) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:organization_id, references(:organizations, on_delete: :delete_all))

      timestamps(type: :utc_datetime)
    end

    create(index(:organizations_users, [:user_id]))
    create(index(:organizations_users, [:organization_id]))
    create(unique_index(:organizations_users, [:organization_id, :user_id]))
  end
end
