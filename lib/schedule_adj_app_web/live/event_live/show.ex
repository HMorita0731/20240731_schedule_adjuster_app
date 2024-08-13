defmodule ScheduleAdjAppWeb.EventLive.Show do
  use  ScheduleAdjAppWeb, :live_view

import Ecto.Query
alias ScheduleAdjApp.Repo
alias ScheduleAdjApp.Events.Event #eventスキーマファイル
alias ScheduleAdjApp.Events.EventDate #event_dateスキーマファイル
alias ScheduleAdjApp.Users.User
alias ScheduleAdjApp.Users.UserDate #＠＠＠足した
alias ScheduleAdjApp.Events
alias Ecto.Multi

def render(assigns) do
  ~H"""
    <% event = Events.get_event(@event) %>
    <div class="text-center text-xl font-bold">
      イベント名： <%= event.title %>
    </div>
    <div>
      作成者：<%= @organizer %>
    </div>
    <div>
      備考：<%= event.memo %>
    </div>

    <div>
      <.button phx-click="input">
        回答する
      </.button>
    </div>

    <!-- IO.inspect(event.event_dates, label: "いべんとでいつ")-->
    <%= if length(@event_date_list) > 0 do %> <!--@はsocket.assignsのキー名そのまま描く-->

      <div :for={date <- @event_date_list} class="my-4 mb-0.5">
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

        <div :for={user <- @user_stru_list} class="mt-1"><!--＠＠＠適当に書いてる, user構造体のリストがuserにはいる-->
          <div class = "mt-1">
            <%= user.name %>
          </div>
          <div class="text-center grid grid-cols-48 grid-rows-1">
            <%= list = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11","12","13","14","15","16","17","18","19","20","21","22","23"]
              for x <- list do
            %>
            <div class="border-l border-y border-gray-600 last:border text-center">
              <% datetime_list = utc_datetime(user)%> <!--#[["2024-07-31", "15:30"],...]-->
                <div class="grid grid-cols-48 grid-rows-1 bg-gray-200">
                  <%= if [date, "#{x}:00"] in @event_datetime_list do %>
                    <div class="!bg-green-200 w-full">
                      〇
                    </div>
                    <%= if [date, "#{x}:00"] in datetime_list do %>
                      <div class="">
                        ◎
                      </div>
                    <% end %>
                  <% else %>
                    <div class="!bg-blue-200 w-full">
                      &nbsp;
                    </div>
                  <% end %>
                </div>

            </div>

            <div class="border-l border-y border-gray-600 last:border text-center grid grid-cols-48 grid-rows-1 bg-gray-200"><!--30分からのところつかさどってる-->
            <%= if  [date, "#{x}:30"] in @event_datetime_list do %>
              <div phx-value-time={"#{x}:30"} phx-value-date={date}
               class = "bg-green-200 w-full">
                〇
              </div>
              <%= if [date, "#{x}:30"] in datetime_list do %>
                <div class="">
                  ◎
                </div>
                    <% end %>
            <% else %>
              <div phx-value-time={"#{x}:30"} phx-value-date={date}
               class = "bg-blue-200 w-full">
                &nbsp;
              </div>
              <% end %>
            </div>
            <% end %><!-- forのend -->

          </div><!-- 45 -->
        </div><!-- ＠＠＠書き足したfor -->
       </div><!-- 表終わり  -->
      </div><!-- for -->
    <% end %><!-- if length のend -->

    <.back navigate={~p"/"}>ホーム画面へ戻る</.back>


    """
  end #render



  def mount(params, _session, socket) do
    event_id = params["event_id"]

    socket =
      socket
      |> assign(:event, event_id)
      #|> assign(:user, session["event"]["input_form"])
      {:ok, socket}

    end #mount

    def handle_params(_params, _uri, socket) do

      # DBからevent_dates構造体を取得し、event_dates_idのみのリストにする
      event_dates_stru = Events.get_event_dates(socket.assigns.event)
      #event_dates_id = Enum.map(event_dates_stru, fn dates -> dates.id end)

      #EventDate構造体から:event_datesをとってきて関数convert_for_showで変換
      str_datetime_list = convert_for_show(Enum.map(event_dates_stru, fn stru -> stru.event_dates end))

      #日付だけとってきて重複とったリスト
      str_date_list = Enum.uniq(Enum.map(str_datetime_list, fn str_datetime -> Enum.at(str_datetime, 0) end))

      #イベント参加者のUser構造体のリスト
      user_stru_list = list_users(socket.assigns.event)

      #参加者ごとの参加可能日のUserDate構造体のリストのリスト　[[太郎さんのUserDate構造体のリスト],[],...]
      user_dates_stru_list_list =Enum.map(user_stru_list,
        fn user_stru -> list_user_dates(user_stru.id) end)
      #参加者ごとの参加可能日のevent_date_idのリストのリスト　[[1, 2, 3, 4, 5], [2, 3, 4, 5], [1, 3, 4, 5], [1, 2, 4, 5]]
      user_dates_id_list_list = Enum.map(user_dates_stru_list_list,
        fn user_dates_stru_list -> Enum.map(user_dates_stru_list, fn user_dates -> user_dates.event_date_id end) end)
      #参加者ごとの参加可能日時をutc_date型で取得
      user_event_detail_list_list = Enum.map(user_dates_id_list_list,
        fn list -> Enum.map(list, fn id -> get_detail_date(id).event_dates end) end)
      #上のやつに関数convert_for_showかけたもの
      user_datetime_detail_list_list = Enum.map(user_event_detail_list_list,
        fn list -> convert_for_show(list) end)
      #イベント作成者一人を取得
      organizer = Enum.at(list_users(socket.assigns.event), 0).name
      #イベント参加者全員取得
      joinners = Enum.map(list_users(socket.assigns.event), fn user_stru -> user_stru.name end)




      socket =
        socket
        |>assign(:organizer, organizer) #主催者の名前
        #|>assign(:joinners, joinners) #参加者の名前リスト
        |>assign(:event_date_list, str_date_list) #日程のリスト
        |>assign(:event_datetime_list, str_datetime_list) #日時のリスト
        #|>assign(:reply, user_dates_stru_list_list) #
        #|>assign(:add_datetime, [])#error防止
        |>assign(:user_datetime_list, user_datetime_detail_list_list)
        |>assign(:user_stru_list, user_stru_list)
        #IO.inspect(socket.assigns, label: "新ソケット")
        {:noreply, socket}
    end #handle

      #replyアクション（回答用ページへ行く）
      def handle_event("input", _params, socket) do
            event_id = socket.assigns.event
            socket =
              socket
              |> redirect(to: ~p"/event/input/#{event_id}")
              {:noreply, socket}
            end#handle_event

          #date型から文字列のリストに変換
          def convert_for_show(datetime_list) do
            Enum.map(datetime_list, fn datetime ->
              [DateTime.to_string(datetime)|>String.split(" ") |> Enum.at(0),
              DateTime.to_string(datetime)|>String.split(" ") |> Enum.at(1) |> String.slice(0..4)]
            end)
          end #convert_for_show

          #event_idからUser構造体のリスト
          def list_users(event_id) do
            User
            |> where([u], u.event_id == ^event_id)
            |> Repo.all()
            # [%User{},...]
          end

          #user_idからUserDate構造体のリスト
          def list_user_dates(user_id) do
            UserDate
            |> where([ud], ud.user_id == ^user_id)
            |> Repo.all()
            # [%UserDate{},...]
          end

          #event_date_idからEventDate構造体取得
          def get_detail_date(event_date_id) do
            EventDate
            |> where([ed], ed.id == ^event_date_id)
            |> Repo.one()
          end

          #user_idからUser構造体取得
          def get_user(user_id) do
            User
            |> where([u], u.id == ^user_id)
            |> Repo.one()
          end

          #user_idからutc型datesを取得
          def utc_datetime(user) do
            user_dates = list_user_dates(user.id)
            |> Enum.map(fn user_dates -> user_dates.event_date_id end)
            |> Enum.map(fn id -> get_detail_date(id).event_dates end)
            |> convert_for_show()
          end #[["2024-07-31", "15:30"],...]

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

# user_datetime_detail_list_list: [
#   [
#     ["2024-07-31", "15:30:00z"],
#     ["2024-07-31", "16", "00"],
#     ["2024-07-31", "16", "30"],
#     ["2024-07-31", "17", "00"],
#     ["2024-07-31", "17", "30"]
#   ],...]
