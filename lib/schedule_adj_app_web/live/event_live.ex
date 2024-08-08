defmodule ScheduleAdjAppWeb.EventLive do
  use ScheduleAdjAppWeb, :live_view

  # ホーム画面

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    live_viewの導入テスト
    """
  end
end
