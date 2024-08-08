defmodule ScheduleAdjApp.EventDates do
  import Ecto.Query
  alias ScheduleAdjApp.Repo
  # eventスキーマファイル
  alias ScheduleAdjApp.Events.Event
  # event_dateスキーマファイル
  alias ScheduleAdjApp.Events.EventDate

  # イベント候補日をDBから取得する関数
  def list_event_dates(event_id) do
    EventDate
    |> where([ed], ed.event_id == ^event_id)
    |> Repo.all()

    # [%EventDate{},...]
  end

  # イベント作成画面で入力された候補日時をDBに入れる関数
  def insert_event_dates(event_dates) do
    Enum.map(event_dates, fn event_date -> Repo.insert(EventDate.changeset(event_date)) end)
  end
end
