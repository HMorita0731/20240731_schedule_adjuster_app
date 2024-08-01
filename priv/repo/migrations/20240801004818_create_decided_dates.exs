defmodule ScheduleAdjApp.Repo.Migrations.CreateDecidedDates do
  use Ecto.Migration

  def change do
    create table(:decided_dates) do
      add :detail, :string
      add :event_date_id, references(:event_dates, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:decided_dates, [:event_date_id])
  end
end
