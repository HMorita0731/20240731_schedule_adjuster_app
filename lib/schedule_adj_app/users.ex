defmodule ScheduleAdjApp.Users do
  import Ecto.Query
  alias ScheduleAdjApp.Repo
  alias ScheduleAdjApp.Events.Event
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
  def insert_user_data(user_datetime_id_list,params,id) do
  Enum.zip(1..length(user_datetime_id_list), user_datetime_id_list)
    |> Enum.reduce(
      # この行から第二引数
      Multi.new()
      |> Multi.insert(:user,change_user(%User{event_id: id},params)),
      # この行から第三引数,multiに処理し終えたマルチ構造体が入っていく
      fn {index, datetime_id}, multi ->
        Multi.insert(
          multi,
          "user_date_#{index}",# ←操作の名前
          fn%{user: user} ->
            UserDate.changeset(%UserDate{user_id: user.id}, %{event_date_id: datetime_id})
          end
        )
      end
    ) # reduce
    |> Repo.transaction()
  end
end

# mod
