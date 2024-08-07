defmodule ScheduleAdjAppWeb.EventLive.Input do
  use  ScheduleAdjAppWeb, :live_view

import Ecto.Query
alias ScheduleAdjApp.Repo
alias ScheduleAdjApp.Events.Event #eventスキーマファイル
alias ScheduleAdjApp.Events.EventDate #event_dateスキーマファイル
alias ScheduleAdjApp.Events 
alias ScheduleAdjApp.Users.User
alias Ecto.Multi

def render(assigns) do
  ~H"""
  予定入力画面
  """

end

def mount(%{"event_id" => params}, session, socket) do
  IO.inspect(params,label: "パラム")
  IO.inspect(session,label: "セッション")
  socket =
    socket
    |> assign(:event_id,params)
  IO.inspect(socket, label: "ソケット")
  {:ok, socket}
end

def handle_params(params, _uri, socket) do
  socket =
    socket
    |> assign(:event_detail,Events.get_event(socket.assigns.event_id))
    |> assign(:event_dates,Events.get_event_dates(socket.assigns.event_id))
    {:noreply, socket}
end #handle

end
