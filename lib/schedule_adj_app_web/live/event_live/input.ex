defmodule ScheduleAdjAppWeb.EventLive.Input do
  use ScheduleAdjAppWeb, :live_view

  import Ecto.Query
  alias ScheduleAdjApp.Repo
  # eventスキーマファイル
  alias ScheduleAdjApp.Events.Event
  # event_dateスキーマファイル
  alias ScheduleAdjApp.Events.EventDate
  alias ScheduleAdjApp.Events
  alias ScheduleAdjApp.Users.User
  alias ScheduleAdjApp.Users
  alias Ecto.Multi

  def render(assigns) do
    ~H"""
    <h2 class="text-4xl"><%= @event_detail.title %></h2>
     <% date_list = make_date_list(@event_dates)%>
     <% datetime_list = make_datetime_list(@event_dates)%>
     <%= if length(date_list) > 0 do %>
  <!--@はsocket.assignsのキー名そのまま描く-->
  <div :for={date <- date_list} class="my-4 w-full">
    <div>
      <%= date %>
      <!-- 日付表示　-->
      <div class="text-center grid grid-cols-24 grid-rows-1"><!--午前中-->
        <%= list = Enum.to_list(0..11)
              for x <- list do %>
        <div class="bg-green-200 text-xs font-bold">
          <%= x %>
        </div>
        <div>
          &nbsp;
        </div>
        <% end %><!-- forのend -->
      </div>
    </div>
    <div class="text-center grid grid-cols-24 grid-rows-1"> <!--ボタン表示 -->
      <%= list = ["00","01","02","03","04","05","06","07","08","09","10","11"]
        for x <- list do %>
        <div class="border-l border-y border-gray-600 last:border"><!--x:00 -->
          <%=if [date,"#{x}:00"] in datetime_list do %>
            <%=if [date,"#{x}:00"] in @add_user_datetime do %>
              <button
                phx-click="delete_time"
                phx-value-time={"#{x}:00"}
                phx-value-date={date}
                class="!bg-blue-200 hover:!bg-blue-400 w-full"
              >
                〇
              </button>
            <%else%>
              <button
                phx-click="select_time"
                phx-value-time={"#{x}:00"}
                phx-value-date={date}
                class="!bg-red-200 hover:!bg-red-400 w-full"
              >
                ×
              </button>
            <%end%><!--if[@add_user_datetime] -->
          <% else %>
            <div
            class="!bg-gray-200 w-full"
            >
              &nbsp;
            </div>
          <%end%><!--if[date]のend -->
        </div>
        <div class="border-l border-y border-gray-600 last:border"><!--x:30 -->
          <%=if [date,"#{x}:30"] in datetime_list do %>
            <%=if [date,"#{x}:30"] in @add_user_datetime do %>
              <button
                phx-click="delete_time"
                phx-value-time={"#{x}:30"}
                phx-value-date={date}
                class="!bg-blue-200 hover:!bg-blue-400 w-full"
              >
                〇
              </button>
            <%else%>
              <button
                phx-click="select_time"
                phx-value-time={"#{x}:30"}
                phx-value-date={date}
                class="!bg-red-200 hover:!bg-red-400 w-full"
              >
                ×
                <%= "#{x}:30" %>
              </button>
            <%end%><!--if[@add_user_datetime] -->
          <% else %>
            <div
            class="!bg-gray-200 w-full"
            >
              &nbsp;
            </div>
          <%end%><!--if[date]のend -->
        </div>
      <% end %><!-- for{list}のend -->
    </div>
    <div>
      <div class="text-center grid grid-cols-24 grid-rows-1"><!--午後-->
        <%= list = Enum.to_list(12..23)
              for x <- list do %>
        <div class="bg-green-200 text-xs font-bold">
          <%= x %>
        </div>
        <div>
          &nbsp;
        </div>
        <% end %><!-- forのend -->
      </div>
    </div>
    <div class="text-center grid grid-cols-24 grid-rows-1"> <!--ボタン表示 -->
      <%= list =  Enum.to_list(12..23)
        for x <- list do %>
        <div class="border-l border-y border-gray-600 last:border"><!--x:00 -->
          <%=if [date,"#{x}:00"] in datetime_list do %>
            <%=if [date,"#{x}:00"] in @add_user_datetime do %>
              <button
                phx-click="delete_time"
                phx-value-time={"#{x}:00"}
                phx-value-date={date}
                class="!bg-blue-200 hover:!bg-blue-400 w-full"
              >
                〇
              </button>
            <%else%>
              <button
                phx-click="select_time"
                phx-value-time={"#{x}:00"}
                phx-value-date={date}
                class="!bg-red-200 hover:!bg-red-400 w-full"
              >
                ×
              </button>
            <%end%><!--if[@add_user_datetime] -->
          <% else %>
            <div
            class="!bg-gray-200 w-full"
            >
              &nbsp;
            </div>
          <%end%><!--if[date]のend -->
        </div>
        <div class="border-l border-y border-gray-600 last:border"><!--x:30 -->
          <%=if [date,"#{x}:30"] in datetime_list do %>
            <%=if [date,"#{x}:30"] in @add_user_datetime do %>
              <button
                phx-click="delete_time"
                phx-value-time={"#{x}:30"}
                phx-value-date={date}
                class="!bg-blue-200 hover:!bg-blue-400 w-full"
              >
                〇
              </button>
            <%else%>
              <button
                phx-click="select_time"
                phx-value-time={"#{x}:30"}
                phx-value-date={date}
                class="!bg-red-200 hover:!bg-red-400 w-full"
              >
                ×
              </button>
            <%end%><!--if[@add_user_datetime] -->
          <% else %>
            <div
            class="!bg-gray-200 w-full"
            >
              &nbsp;
            </div>
          <%end%><!--if[date]のend -->
        </div>
      <% end %><!-- for{list}のend -->
    </div>
  </div> <% end %><!-- for{date}のend --><!-- 日付表示ここまで -->
  <.simple_form
  for={@form}
  phx-submit="insert_user_dates"
  action={~p"/event/event/show/:event_id"}
  >
  <.input field={@form[:name]} type="text" label="ニックネーム(必須)" />
  <.input field={@form[:pass]} type="text" label="パスワード(必須)" />
  <.input field={@form[:memo]} type="textarea" label="備考" />
  <:actions>
    <.button>
      日程を登録する
    </.button>
  </:actions>
  </.simple_form>
    """
  end

  def mount(%{"event_id" => params}, session, socket) do

    socket =
      socket
      |> assign(:event_id, params)
      |> assign(:add_user_datetime,[])

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign(:event_detail, Events.get_event(socket.assigns.event_id))
      |> assign(:event_dates, Events.get_event_dates(socket.assigns.event_id))
      |> assign(:add_user_datetime, make_datetime_list(Events.get_event_dates(socket.assigns.event_id)))
      |> assign(:page_title, "日程登録")
      |> assign(:user,%User{})
      |> assign_form(Users.change_user(%User{}))
      #%Event{}と[%EventDate{}]

    {:noreply, socket}
  end
  # handle

   # 時間選択機能
   def handle_event("select_time", %{"date"=>date,"time"=>time}, socket) do
    socket =
      socket
      # 複数選択した時刻をリストに追加していく
      |> assign(:add_user_datetime, Enum.uniq(List.insert_at(socket.assigns.add_user_datetime, -1, [date,time])))

    {:noreply, socket}
  end

  def handle_event("delete_time", %{"date"=>date,"time"=>time}, socket) do
    new_add_user_datetime = socket.assigns.add_user_datetime -- [[date,time]]

    socket =
      socket
      # 複数選択した時刻をリストに追加していく
      |> assign(:add_user_datetime, new_add_user_datetime)

      {:noreply, socket}
    end

    def handle_event("validate", %{"user_input" => params}, socket) do
      IO.inspect(params)
      cs = Users.change_user(socket.assigns.user_input, params)
      {:noreply, assign_form(socket, cs)}
    end

    def handle_event("insert_user_dates", %{"user_input" => params}, socket) do
      IO.inspect(params)
      {:noreply, socket}
    end

  def make_date_list(event_date_list) do
    #[%EventDate{}]
    Enum.map(event_date_list,fn %{event_dates: event_date} -> DateTime.to_string(event_date) end)
    |> Enum.map(fn str_datetime -> String.split(str_datetime," ") end)
    |> Enum.map(fn [str_date, _str_time] -> str_date end)
    |> Enum.uniq()
  end

  def make_datetime_list(event_date_list) do
    #[%EventDate{}]
    Enum.map(event_date_list,fn %{event_dates: event_date} -> DateTime.to_string(event_date) end)
    |> Enum.map(fn str_datetime -> String.split(str_datetime," ") end)
    |> Enum.map(fn [str_date, str_time] -> [str_date,String.slice(str_time,0,5)] end)
  end


  # ソケットにcsをフォーム型にして挿入
  defp assign_form(socket, cs) do
    assign(socket, :form, to_form(cs, as: "user_input"))
  end

  # date型から変換(まだ試してない)
  # defp convert_from_datetime(datetime) do
  # date = DateTime.to_string(datetime)|>String.split(" ") |> Enum.at(0)
  # time = DateTime.to_string(datetime)|>String.split(" ") |> Enum.at(1)
  # [date, time]
  # end #convert_from_datetime
end
