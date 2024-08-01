defmodule ScheduleAdjApp.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias ScheduleAdjApp.Users.User
  alias ScheduleAdjApp.Events.EventDate

  schema "events" do
    field :title, :string
    field :memo, :string
    field :status, :integer #集計中かどうか(0/集計中, 1/集計終了,)

    has_many :users, User
    has_many :event_dates, EventDate

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :memo, :status])
    |> validate_required([:title, :status])
  end
end
