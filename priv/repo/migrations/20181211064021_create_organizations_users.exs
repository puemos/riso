defmodule Riso.Repo.Migrations.CreateOrganizationsMembers do
  use Ecto.Migration

  def change do
    create table(:organizations_members) do
      add(:role, :string)
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:organization_id, references(:organizations, on_delete: :delete_all))

      timestamps(type: :utc_datetime)
    end

    create(index(:organizations_members, [:user_id]))
    create(index(:organizations_members, [:organization_id]))
    create(unique_index(:organizations_members, [:organization_id, :user_id]))
  end
end
