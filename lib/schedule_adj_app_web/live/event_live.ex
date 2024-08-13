defmodule ScheduleAdjAppWeb.EventLive do
  use ScheduleAdjAppWeb, :live_view

  # ホーム画面

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-4xl">Teki Paki</h1>
    <.link href={~p"/event/new"}>
    イベント新規作成
    </.link>
    """
  end
end
