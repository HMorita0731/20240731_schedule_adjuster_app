defmodule ScheduleAdjApp.Events do
  import Ecto.Query
  alias ScheduleAdjApp.Repo
  # eventスキーマファイル
  alias ScheduleAdjApp.Events.Event
  # event_dateスキーマファイル
  alias ScheduleAdjApp.Events.EventDate
  alias ScheduleAdjApp.Users.User
  alias Ecto.Multi

  # イベント系DBやり取り機能　まとめ

  # イベントIDからイベントを取ってくる関数、戻り値はEvent構造体
  def get_event(id) do
    Event
    |> where([e], e.id == ^id)
    |> Repo.one()
  end

  def get_event_dates(id) do
    EventDate
    |> where([ed], ed.event_id == ^id)
    |> Repo.all()
  end

  # イベントを作ってDBに入れる関数
  def create_event(attrs \\ %{}) do
    Event
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  # トランザクション処理
  def insert_form(params, datetime_list) do
    # Multi.new()
    # |> Multi.insert(:event, Event.changeset(%Event{},params))
    # |> Multi.insert(:user, fn %{event: event} ->
    #   User.changeset(%User{event_id: event.id}, params) end)
    # |> Multi.insert(:event_date,fn %{event: event} ->
    #   EventDate.changeset(%EventDate{event_id: event.id},params) end)
    # |> Repo.transaction()

    Enum.zip(1..length(datetime_list), datetime_list)
    |> Enum.reduce(
      # この行から第二引数
      Multi.new()
      |> Multi.insert(:event, Event.changeset(%Event{}, params))
      |> Multi.insert(:user, fn %{event: event} ->
        User.changeset(%User{event_id: event.id}, params)
      end),
      # この行から第三引数,multiに処理し終えたマルチ構造体が入っていく
      fn {index, datetime}, multi ->
        Multi.insert(
          multi,
          # ←操作の名前
          "event_date_#{index}",
          fn %{event: event} ->
            EventDate.changeset(%EventDate{event_id: event.id}, %{event_dates: datetime})
          end
        )
      end
    )

    # reduce
    |> Repo.transaction()
  end

  # insert_form

  # csを用意する関数
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  # change_event

  # Gets the event with the given signed token
  def get_event_by_session_token(token) do
    {:ok, query} = EventToken.verify_session_token_query(token)
    Repo.one(query)
  end
end

# mod
