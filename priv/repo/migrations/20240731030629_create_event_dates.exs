defmodule ScheduleAdjApp.Repo.Migrations.CreateEventDate do
  use Ecto.Migration

  def change do
    create table(:event_dates) do
      add :event_dates, :utc_datetime, null: false
      add :event_id, references(:events, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:event_dates, [:event_id])
  end
end
