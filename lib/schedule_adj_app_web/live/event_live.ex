defmodule ScheduleAdjAppWeb.EventLive do
  use ScheduleAdjAppWeb, :live_view

  # ホーム画面

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="text-center">
        イベント作成者も参加者も見やすい！答えやすい！
      </div>
      <div class="text-center">
        〇と×だけで構成された
      </div>
      <div class="text-center">
        テキパキ決まるスケジュール調整アプリです
      </div>
      <div class="text-center my-20">
        <.link patch={~p"/event/new"}>
            <.button>イベントを作る</.button>
        </.link>
      </div>


    """
  end
end
