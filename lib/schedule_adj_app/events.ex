defmodule ScheduleAdjApp.Events do
import Ecto.Query
alias ScheduleAdjApp.Repo
alias ScheduleAdjApp.Events.Event #eventスキーマファイル
alias ScheduleAdjApp.Events.EventDate #event_dateスキーマファイル
alias ScheduleAdjApp.Users.User
alias Ecto.Multi

# イベント系DBやり取り機能　まとめ

# イベントIDからイベントを取ってくる関数
def get_event(id) do
  Event
  |> where([e], e.id == ^id)
  |> Repo.one()
end

#イベントを作ってDBに入れる関数
def create_event(attrs \\ %{}) do
    Event
    |> Event.changeset(attrs)
    |> Repo.insert()
end

#トランザクション処理
def insert_form(params) do
  Multi.new()
  |> Multi.insert(:event, Event.changeset(%Event{},params))
  |> Multi.insert(:user, fn %{event: event} ->
    User.changeset(%User{event_id: event.id}, params) end)
  |> Multi.insert(:event_date,fn %{event: event} ->
    EventDate.changeset(%EventDate{event_id: event.id},params) end)
  |> Repo.transaction()
end


#csを用意する関数
def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
end



end
