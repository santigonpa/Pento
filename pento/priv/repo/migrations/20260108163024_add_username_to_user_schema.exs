defmodule Pento.Repo.Migrations.AddUsernameToUserSchema do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:username, :string, unique: true, required: true)
    end

    create(unique_index(:users, [:username]))
  end
end
