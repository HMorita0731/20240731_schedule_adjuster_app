defmodule ScheduleAdjApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ScheduleAdjApp.Events.Event
  alias ScheduleAdjApp.Events.EventDate

  schema "users" do
    field :name, :string
    field :pass, :string
    field :memo, :string
    belongs_to :event, Event

    timestamps(type: :utc_datetime)

    many_to_many(:event_dates, EventDate, join_through: "user_dates")
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :pass, :memo, :event_id])
    |> validate_required([:name, :pass, :event_id])
  end

  def changeset_for_event_insert(user, attrs) do
    user
    |> cast(attrs, [:name, :pass, :memo])
    |> validate_required([:name, :pass])
  end
end
