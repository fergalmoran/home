defmodule Home.Repo.Migrations.AddOauthToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :provider, :string
      add :provider_id, :string
      add :avatar_url, :string
      add :name, :string
    end

    # Make password nullable for OAuth users
    execute "ALTER TABLE users ALTER COLUMN hashed_password DROP NOT NULL",
            "ALTER TABLE users ALTER COLUMN hashed_password SET NOT NULL"

    # Create unique index on provider + provider_id
    create unique_index(:users, [:provider, :provider_id],
             where: "provider IS NOT NULL",
             name: :users_provider_provider_id_index
           )
  end
end
