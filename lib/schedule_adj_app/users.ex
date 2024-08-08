defmodule ScheduleAdjApp.Users do
  import Ecto.Query
  alias ScheduleAdjApp.Repo
  # eventスキーマファイル
  alias ScheduleAdjApp.Events.Event
  # event_dateスキーマファイル
  alias ScheduleAdjApp.Events.EventDate
  alias ScheduleAdjApp.Users.User
  alias ScheduleAdjApp.Users.UserDate
  alias Ecto.Multi

  # csを用意する関数
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  # change_user

  def change_user_for_event_insert(%User{} = user, attrs \\ %{}) do
    User.changeset_for_event_insert(user, attrs)
  end

  # change_user_for_event_insert
end

# mod
