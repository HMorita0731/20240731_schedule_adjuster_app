defmodule ScheduleAdjAppWeb.EventLive.Show do
  use  ScheduleAdjAppWeb, :live_view

import Ecto.Query
alias ScheduleAdjApp.Repo
alias ScheduleAdjApp.Events.Event #eventスキーマファイル
alias ScheduleAdjApp.Events.EventDate #event_dateスキーマファイル
alias ScheduleAdjApp.Users.User
alias ScheduleAdjApp.Events
alias Ecto.Multi

def render(assigns) do
  ~H"""
    <% event = Events.get_event(@event) %>

    イベント名： <%= event.title %>
    作成者：<%= @user["name"]%>
    備考：<%= event.memo %>

    <div>
      <.button phx-click="input">
        回答する
      </.button>
    </div>

    <!-- IO.inspect(event.event_dates, label: "いべんとでいつ")-->
    <%= if length(@str_date_list) > 0 do %> <!--@はsocket.assignsのキー名そのまま描く-->

      <div :for={date <- @str_date_list} class="my-4">
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

        </div><!-- 45 -->
       </div><!-- 表終わり  -->
      </div><!-- for -->
    <% end %><!-- if length のend -->

    <.back navigate={~p"/"}>ホーム画面へ戻る</.back>


    """
  end #render



  def mount(params, session, socket) do
    event_id = params["event_id"]

    socket =
      socket
      |> assign(:event, event_id)
      |> assign(:user, session["event"]["input_form"])
      #IO.inspect(socket.assigns.user, label: "ソケット")
      {:ok, socket}

    end #mount

    def handle_params(_params, _uri, socket) do

      event_dates_stru = Events.get_event_dates(socket.assigns.event)
      event_datetimes = Enum.map(event_dates_stru, fn stru -> stru.event_dates end)
      str_datetime_list = convert_for_show(event_datetimes)
      str_date_list_tem = Enum.map(str_datetime_list, fn str_datetime -> Enum.at(str_datetime, 0) end)
      str_date_list = Enum.uniq(str_date_list_tem)

      socket =
        socket
        |>assign(:str_date_list, str_date_list)
        |>assign(:add_date, []) #空のadd_dateリストをソケットに用意
        |>assign(:add_datetime,[]) #空のadd_datetimeリストをソケットに用意
        IO.inspect(socket.assigns, label: "新ソケット")
        {:noreply, socket}
    end #handle

      #replyアクション（回答用ページへ行く）
      def handle_event("input", _params, socket) do
        # IO.inspect assigns: %{
          #   user: %{
            #     "memo" => "",
            #     "name" => "みわ",
            #     "pass" => "あいう",
            #     "title" => "ランチ"
            #   }
            grape = socket.assigns.event
            socket =
              socket
              |> redirect(to: ~p"/event/input/#{grape}")
              {:noreply, socket}
            end#handle_event

           #date型から文字列のリストに変換
          def convert_for_show(datetime_list) do
            Enum.map(datetime_list, fn datetime ->
              [DateTime.to_string(datetime)|>String.split(" ") |> Enum.at(0),
              DateTime.to_string(datetime)|>String.split(" ") |> Enum.at(1)]
            end)

          end #convert_for_show
          # [["2024-08-28", "15:30:00Z"], ...]

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


# assigns: #Phoenix.LiveView.Socket<
#   id: "phx-F-mbRN6AUkCPegAD",
#   endpoint: ScheduleAdjAppWeb.Endpoint,
#   view: ScheduleAdjAppWeb.EventLive.Show,
#   parent_pid: nil,
#   root_pid: #PID<0.820.0>,
#   router: ScheduleAdjAppWeb.Router,
#   assigns: %{
#     __changed__: %{event: true},
#     flash: %{},
#     event: "6",
#     live_action: :show

# assigns.user: %{
#   "memo" => "",
#   "name" => "みわ",
#   "pass" => "あいう",
#   "title" => "ランチ"
# }
