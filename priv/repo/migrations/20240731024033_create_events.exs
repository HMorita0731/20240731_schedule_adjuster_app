defmodule ScheduleAdjApp.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string, null: false
      add :memo, :string
      add :status, :integer, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
