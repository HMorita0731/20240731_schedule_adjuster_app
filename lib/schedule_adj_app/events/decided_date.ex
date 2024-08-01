defmodule ScheduleAdjApp.Events.DecidedDate do
  use Ecto.Schema
  import Ecto.Changeset
  alias ScheduleAdjApp.Events.EventDate

  schema "decided_dates" do
    field :detail, :string
    belongs_to :event_dates, EventDate

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(decided_date, attrs) do
    decided_date
    |> cast(attrs, [:detail, :event_date_id])
    |> validate_required([:detail, :event_date_id])
  end
end
