defmodule ScheduleAdjAppWeb.EventLive.Show do
  use  ScheduleAdjAppWeb, :live_view

import Ecto.Query
alias ScheduleAdjApp.Repo
alias ScheduleAdjApp.Events.Event #eventスキーマファイル
alias ScheduleAdjApp.Events.EventDate #event_dateスキーマファイル
alias ScheduleAdjApp.Users.User
alias Ecto.Multi

def render(assigns) do
  ~H"""
<!-- event = get_event(@event.id)-->
<!-- <%=  @event.title %>

    <%= if length(@add_date) > 0 do %> <!--@はsocket.assignsのキー名そのまま描く-->
       <!-- 時刻をソケットに入れる　-->
       <div :for={date <- @add_date} class="my-4">
        <%= date %>
       <div class="w-full">
        <div class="text-center grid grid-cols-48 grid-rows-1">
          <%= list = Enum.to_list(0..23)
            for x <- list do
          %>
          <div class="bg-green-200 text-xs font-bold">
            <%= x %>
          </div>
          <div>
           &nbsp;
          </div>
           <% end %><!-- forのend -->
        </div>
        <div class="text-center grid grid-cols-48 grid-rows-1">
          <%= list = Enum.to_list(0..23)
            for x <- list do
          %>
          <div class="border-l border-y border-gray-600 last:border">
            <%= if %{"date"=>date,"time"=>"#{x}:00","value"=>""} in @add_datetime do %>
              <button phx-click="select_time" phx-value-time={"#{x}:00"} phx-value-date={date}
              class = "!bg-green-200 hover:!bg-green-400 w-full">
                &nbsp;
              </button>
            <% else %>
              <button phx-click="select_time" phx-value-time={"#{x}:00"} phx-value-date={date}
              class = "!bg-blue-200 hover:!bg-blue-400 w-full">
                &nbsp;
              </button>
            <% end %>
          </div>
          <div class="border-l border-y border-gray-600 last:border">
          <%= if %{"date"=>date,"time"=>"#{x}:30","value"=>""} in @add_datetime do %>
            <button phx-click="select_time" phx-value-time={"#{x}:30"} phx-value-date={date}
            class = "!bg-green-200 hover:!bg-green-400 w-full">
              &nbsp;
            </button>
            <% else %>
            <button phx-click="select_time" phx-value-time={"#{x}:30"} phx-value-date={date}
            class = "!bg-blue-200 hover:!bg-blue-400 w-full">
              &nbsp;
            </button>
            <% end %>
          </div>
          <% end %><!-- forのend -->
          </div>
       </div><!-- 表終わり  -->
       </div>
    <% end %><!-- if length のend -->

    <.back navigate={~p"/"}>ホーム画面へ戻る</.back>


    """
  end #render

  def mount(params, _session, socket) do
    IO.inspect(params,label: "パラム")
    socket
    |> assign(:event_id, params)

    {:ok, socket}

  end #mount

   # event = Events.get_event_by_session_token(session["event_token"])
   # {:ok, assign(socket, :current_event, event)}


  def handle_params(_params, _uri, socket) do
    socket =
      socket
      |>assign(:add_date, []) #空のadd_dateリストをソケットに用意
      |>assign(:add_datetime,[]) #空のadd_datetimeリストをソケットに用意
      {:noreply, socket}
  end #handle


# event_idで各種情報を取ってくる
# title取得関数
# memo(備考)取得関数
# 作成者名取得関数

# event_dateのリスト取得関数

# date_time取得関数

end #mod

# 回答画面遷移ボタン(input)
# 名前クリックで回答編集（パス要求）へ
# コメント表示
# 作成者用編集ボタン
