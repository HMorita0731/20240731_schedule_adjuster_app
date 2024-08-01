defmodule ScheduleAdjApp.Users.UserDate do
  use Ecto.Schema
  import Ecto.Changeset
  alias ScheduleAdjApp.Users.User
  alias ScheduleAdjApp.Events.EventDate

  schema "user_dates" do

    belongs_to :user, User
    belongs_to :event_date, EventDate

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_dates, attrs) do
    user_dates
    |> cast(attrs, [:user_id,:event_date_id])
    |> validate_required([:user_id,:event_date_id])
  end
end
