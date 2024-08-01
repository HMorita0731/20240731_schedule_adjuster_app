defmodule ScheduleAdjApp.Repo.Migrations.CreateUserDate do
  use Ecto.Migration

  def change do
    create table(:user_dates) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :event_date_id, references(:event_dates, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:user_dates, [:user_id])
    create index(:user_dates, [:event_date_id])
  end
end
