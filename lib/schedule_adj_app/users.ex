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

#   # change_user_for_event_insert
#   def insert_user_data(params,user_datatime_list) do
#   Enum.zip(1..length(user_datetime_list), user_datetime_list)
#     |> Enum.reduce(
#       # この行から第二引数
#       Multi.new()
#       |> Multi.insert(:user, fn %{event: event} ->
#         User.changeset(%User{event_id: event.id}, params)
#       end),
#       # この行から第三引数,multiに処理し終えたマルチ構造体が入っていく
#       fn {index, datetime}, multi ->
#         Multi.insert(
#           multi,
#           "user_date_#{index}",# ←操作の名前
#           fn %{event: event} ->
#             EventDate.changeset(%EventDate{event_id: event.id}, %{event_dates: datetime})
#           end
#         )
#       end
#     )

#     # reduce
#     |> Repo.transaction()
#   end
 end

# mod
