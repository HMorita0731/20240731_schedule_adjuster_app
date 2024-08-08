defmodule ScheduleAdjApp.Events.EventDate do
  use Ecto.Schema
  import Ecto.Changeset
  alias ScheduleAdjApp.Events.Event
  alias ScheduleAdjApp.Users.User
  alias ScheduleAdjApp.Events.DecidedDate

  schema "event_dates" do
    field :event_dates, :utc_datetime
    belongs_to :event, Event

    has_many :decided_dates, DecidedDate

    timestamps(type: :utc_datetime)
    many_to_many(:users, User, join_through: "user_dates")
  end

  @doc false
  def changeset(event_date, attrs) do
    event_date
    |> cast(attrs, [:event_dates, :event_id])
    |> validate_required([:event_dates, :event_id])
  end
end
