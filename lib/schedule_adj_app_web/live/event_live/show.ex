defmodule ScheduleAdjAppWeb.EventLive.Show do
  use  ScheduleAdjAppWeb, :live_view

import Ecto.Query
alias ScheduleAdjApp.Repo
alias ScheduleAdjApp.Events.Event #eventスキーマファイル
alias ScheduleAdjApp.Events.EventDate #event_dateスキーマファイル
alias ScheduleAdjApp.Users
alias ScheduleAdjApp.Users.User
alias ScheduleAdjApp.Users.UserDate
alias ScheduleAdjApp.Events
alias Ecto.Multi

def render(assigns) do
  ~H"""
    <% event = Events.get_event(@event) %>
    <div class="text-center text-xl font-bold bg-green-200">
      イベント名： <%= event.title %>
    </div>
    <div>
      作成者：<%= @organizer %>
    </div>
    <div>
      備考：<%= event.memo %>
    </div>
    <div class="font-bold">
      イベント作成者の方は、このページのURLを参加候補者に配布してください！
    </div>


    <div class="mt-4  grid grid-cols-3 grid-rows-1">
      <.button phx-click="input"
        class="w-1/2 ">
        回答する
      </.button>
      <div class="text-right col-span-2">
        全員が来れる日時には◎をつけてわかりやすく表示されます！
      </div>
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
          <%= if [date, "#{x}:30"] in @event_datetime_list && all_okay(get_eventdate([date, "#{x}:30"],event), event) do%>
                <div class="bg-green-400 border-l border-y border-white last:border text-xs">
                  <%= x %>
                </div>
            <%else%>
              <div class="bg-green-200 border-l border-y border-white last:border text-xs">
              <%= x %>
              </div>
            <% end %>
            <%= if [date, "#{x}:30"] in @event_datetime_list && all_okay(get_eventdate([date, "#{x}:30"],event), event) do%>
                <div class="bg-green-400 border-l border-y border-white last:border">
                  &nbsp;
                </div>
            <%else%>
              <div class="bg-green-200 border-l border-y border-white last:border">
                &nbsp;
              </div>
            <% end %>
          <% end %><!-- forのend -->
        </div>

        <div :for={user <- @user_stru_list} class="mt-1"><!--＠＠＠適当に書いてる, user構造体のリストがuserにはいる-->
          <div class = "mt-1">

          <button
          phx-click="input_pass"
          phx-value-user_id= {user.id}
          >
            <%= user.name %>

          </button>
          <%=if @set_user_id == user.id do %>
            <div>
            <form
            phx-submit="check_pass"

            >
              <input type="text" name="pass" class="h-1">
              <button class="h-2/5 text-xs text-white bg-black px-1 rounded-md">
                編集
              </button>
            </form>
            </div>
          <% end%>
          </div>
          <div class="text-center  grid grid-cols-48 grid-rows-1">
            <%= list = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11","12","13","14","15","16","17","18","19","20","21","22","23"]
              for x <- list do
            %>
              <div class="border-l border-y border-gray-600 last:border ">
                <% datetime_list = utc_datetime(user)%> <!--#[["2024-07-31", "15:30"],...]-->
                <%= if  [date, "#{x}:00"] in @event_datetime_list do %>
                <%= if [date, "#{x}:00"] in datetime_list do %>
                    <%= if all_okay(get_eventdate([date, "#{x}:00"],event), event) do %>
                    <div class="!bg-blue-400 text-xs h-full flex items-center">
                    <div>
                    ◎
                    </div>
                    </div>
                  <% else %>
                  <div class=" bg-blue-200 text-xs h-full flex items-center">
                  <div>
                  〇
                  </div>
                  </div>
                  <% end %>
                <% else %>
                <div phx-value-time={"#{x}:00"} phx-value-date={date}
                class = "bg-red-200 w-full flex items-center">
                  <div>
                    ×
                  </div>
                </div>
                      <% end %>
              <% else %>
                <div phx-value-time={"#{x}:00"} phx-value-date={date}
                class = "bg-gray-200 w-full">
                  &nbsp;
                </div>
                <% end %>
              </div>
              <div class="border-l border-y border-gray-600 last:border text-center"><!--30分からのところつかさどってる-->
              <%= if  [date, "#{x}:30"] in @event_datetime_list do %>
                <%= if [date, "#{x}:30"] in datetime_list do %>
                <%= if all_okay(get_eventdate([date, "#{x}:30"],event), event) do %>
                <div class="!bg-blue-400 text-xs h-full flex items-center">
                    <div>
                    ◎
                    </div>
                </div>
                  <% else %>
                  <div class=" bg-blue-200 text-xs h-full flex items-center">
                  <div>
                  〇
                  </div>
                  </div>
                  <%end%>
                <% else %>
                <div phx-value-time={"#{x}:30"} phx-value-date={date}
                class = "bg-red-200 w-full flex items-center">
                <div>
                ×
                </div>
                </div>
                <% end %>
              <% else %>
                <div phx-value-time={"#{x}:30"} phx-value-date={date}
                class = "bg-gray-200 w-full">
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

    <div class="my-4"><!-- 回答者コメント全体 -->
      <div :for={user <- @user_stru_list -- [Enum.at(@user_stru_list, 0)]} class="mt-1 my-4 bg-blue-200">
        <%= unless is_nil(user.memo)  do %>
          <%=user.name%>のコメント：<%=user.memo%>
        <%end%><!--if end-->
      </div><!--:for={user <- @user_stru_list-->
    </div><!-- 回答者コメント全体 -->

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
      str_datetime_list =
      Events.get_event_dates(socket.assigns.event)
      |>Enum.map(fn stru -> stru.event_dates end)###  #EventDate構造体から:event_datesをとってきて関数convert_for_showで変換
      |>convert_for_show()
      #日付だけとってきて重複とったリスト
      str_date_list = Enum.uniq(Enum.map(str_datetime_list, fn str_datetime -> Enum.at(str_datetime, 0) end))###
      #イベント参加者のUser構造体のリスト

      user_stru_list = Users.list_users(socket.assigns.event) ###

      organizer = Enum.at(Users.list_users(socket.assigns.event), 0).name #イベント作成者一人を取得 ###

      socket =
        socket
        |>assign(:organizer, organizer) #主催者の名前
        |>assign(:event_date_list, str_date_list) #日程のリスト
        |>assign(:event_datetime_list, str_datetime_list) #日時のリスト
        |>assign(:user_stru_list, user_stru_list)
        |> assign(:set_user_id, nil)
        |> assign(trigger_submit: false)
        #IO.inspect(socket.assigns, label: "新ソケット")
        {:noreply, socket}
    end #handle

      #inputアクション（回答用ページへ行く）
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

      #user_idからutc型datesを取得
      def utc_datetime(user) do
      user.event_dates
      |> Enum.map(fn user_date -> user_date.id end)
      |> Enum.map(fn id -> Events.get_detail_date(id).event_dates end)
      |> convert_for_show()
      end #[["2024-07-31", "15:30"],...]

      def handle_event("input_pass", %{"user_id" => user_id}, socket) do
        id =
          unless user_id == "#{socket.assigns.set_user_id}" do
            String.to_integer(user_id)
          end
          {:noreply, assign(socket, :set_user_id, id)}
      end


          #全員〇の日ハイライト
          def all_okay(eventdate, event) do
             event_length = length(Repo.preload(event, :users).users)
             eventdate_length = length(Repo.preload(eventdate, :users).users)
              if event_length == eventdate_length do
                true
              else
                false
              end

          end

          #文字列のdatetimeからeventdate構造体取得
          def get_eventdate([date, time],event) do

            x = ScheduleAdjAppWeb.EventLive.AddDate.convert_datetime(date, time)
            eventdate =
            EventDate
            |> where([e], e.event_dates == ^x)
            |> where([e], e.event_id == ^event.id)
            |> Repo.one()

          end#%Eventdate{}

          # [["2024-08-28", "15:30:00Z"], ...]


      def handle_event("check_pass", %{"pass" => pass}, socket) do
        user = Users.get_user(socket.assigns.set_user_id)
        socket =
        if pass == user.pass do
          socket
          #|> assign(trigger_submit: true)
          |> redirect(to: ~p"/event/update/#{user.event_id}/#{user.id}")
        else
          socket
          |> put_flash(:error,"パスワードが違います")
        end

        {:noreply, socket}

      end

end #mod

# phx-trigger-action={@trigger_submit}
#             action={~p"/event/update/#{user.event_id}/#{user.id}"}
#             method="post

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
