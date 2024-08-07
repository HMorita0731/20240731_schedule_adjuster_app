defmodule ScheduleAdjAppWeb.EventLive.AddDate do
  use  ScheduleAdjAppWeb, :live_view

  alias ScheduleAdjApp.Events #eventのDAO
  alias ScheduleAdjApp.Events.Event #eventスキーマファイル
  alias ScheduleAdjApp.Events.EventDate #eventdateスキーマファイル
  alias ScheduleAdjApp.Users #UserDao
  alias ScheduleAdjApp.Users.User #Userスキーマファイル


  #   def render(assigns) do
  #   ~H"""


  #   """
  # end #render

  def mount(params, session, socket) do
    IO.inspect(session,label: "セッション")
    IO.inspect(session["event"]["input_form"], label: "イベント")

    #セッションから情報をソケットに入れる
    socket =
      socket
      |> assign(:input_form, session["event"]["input_form"])

    IO.inspect(socket)
    {:ok, socket}
  end #mount
  # セッションの中身: %{
  #   "_csrf_token" => "eJt5PzhOj6RIDwcEC5NkF9MS",
  #   "event" => %{
  #     "_csrf_token" => "FXhZfiVNHj8pXhMFMSNXEzB4CA0tUiEWp2-Ku7vpChALuT4VsMFfkklE",
  #     "input_form" => %{
  #       "memo" => "",
  #       "name" => "テスターA",
  #       "pass" => "qaz",
  #       "title" => "おためし"
  #     }
  #   }
  # }




  def handle_params(_params, _uri, socket) do
    socket =
      socket
      |>assign(:add_date, []) #空のadd_dateリストをソケットに用意
      |>assign(:add_datetime,[]) #空のadd_datetimeリストをソケットに用意
      {:noreply, socket}
  end #handle


  # 日付選択機能
  def handle_event("select_date", %{"add_date" => params}, socket) do
    socket =
    socket
      # 複数選択した日付をリストに追加していく
      |> assign(:add_date, Enum.uniq(List.insert_at(socket.assigns.add_date, -1, params)))
    {:noreply, socket}
  end #handle_event
  #IO.inspect →Parameters: %{"add_date" => "2024-08-02"}

  #socketから日付(add_date)を削除する
  def handle_event("delete_date", %{"date" => params_date} = params, socket) do
    new_add_date =
      socket.assigns.add_date -- [params_date] #日付を消す

    new_add_datetime = #時間を消す
      Enum.reject(socket.assigns.add_datetime, fn %{"date" => x} -> x == params_date end) #条件式に当てはまらないものだけを残す関数

    socket = #socketを消去後上書き
      socket
      |>assign(:add_date, new_add_date)
      |>assign(:add_datetime, new_add_datetime)

      IO.inspect(socket.assigns.add_date, label: "削除後add_date")
      IO.inspect(socket.assigns.add_datetime, label: "削除後add_datetime")

   {:noreply, socket}
  end #handle_event("delete_date")

 # 時間選択機能
  def handle_event("select_time", params, socket) do
   socket=
   socket
    # 複数選択した時刻をリストに追加していく
   |> assign(:add_datetime, Enum.uniq(List.insert_at(socket.assigns.add_datetime, -1, params)))
   IO.inspect(socket.assigns, label: "アサインズ")
    {:noreply, socket}
  end #handle_event
  # Parameters: %{"time" => "12:00", "value" => ""}

  #socketから時間(add_datetime)を削除する
  def handle_event("delete_time", params, socket) do
    new_add_datetime =
      socket.assigns.add_datetime -- [params]

    socket =
      socket
      |>assign(:add_datetime, new_add_datetime)
      IO.inspect(socket.assigns.add_datetime)

   {:noreply, socket}
  end #handle_event("delete_time")

#createアクション(transactionで全部dbに入れる)
def handle_event("create", _params, socket) do
  #socketから情報を取り出してdate, timeそれぞれ束縛し、くっつけて変換
  datetime_list = #[~U"",] socket.assigns.input_form->dataが入ってる
    Enum.map(socket.assigns.add_datetime, fn %{"date" => date, "time" => time} ->
    convert_datetime(date, time) end)
    socket =
    case Events.insert_form(socket.assigns.input_form, datetime_list) do
      {:ok,transaction} ->
        socket
        |> put_flash(:info, "新しいイベントを登録しました")
        |> redirect(to: ~p"/event/show/#{transaction.event.id}")



      {:error,action,_ ,_ } -> #引数の数4かも
        socket
        |> put_flash(:error, "#{action}で登録に失敗しました")
 end #case

  {:noreply, socket}
end #handle_event


  # イベント登録関数
  defp save_event(socket, :new, params) do
    case Events.create_event(params) do
    {:ok, event} ->
          socket
          |> put_flash(:info, "作成成功です")
          |> redirect(to: ~p"/event/show/#{event}")
    {:error, cs} ->
   #       assign_form(socket, cs)
    end #case

  end #save_event

#datetimeを作る文字列になっているdateとtimeをintにしてからdate型に変換
defp convert_datetime(date,time) do
  [year,month,day] = Enum.map(String.split(date,"-"),fn x -> String.to_integer(x) end)
  [hour, minute] = Enum.map(String.split(time,":"),fn x -> String.to_integer(x) end)
  {:ok,int_date} = Date.new(year,month,day)
  {:ok, int_time} = Time.new(hour,minute,0)
  DateTime.new!(int_date,int_time)
end #convert_datetime


#date型から変換(まだ試してない)
#defp convert_from_datetime(datetime) do
 # date = DateTime.to_string(datetime)|>String.split(" ") |> Enum.at(0)
 # time = DateTime.to_string(datetime)|>String.split(" ") |> Enum.at(1)
 #[date, time]
#end #convert_from_datetime

# アサインズ: %{
#   __changed__: %{add_datetime: true},
#   flash: %{},
#   add_date: ["2024-08-07", "2024-08-08"],
#   live_action: :add_date,
#   add_datetime: [
#     %{"date" => "2024-08-07", "time" => "6:00", "value" => ""},
#     %{"date" => "2024-08-07", "time" => "7:00", "value" => ""},
#     %{"date" => "2024-08-07", "time" => "7:30", "value" => ""},
#     %{"date" => "2024-08-07", "time" => "8:00", "value" => ""},
#     %{"date" => "2024-08-08", "time" => "14:00", "value" => ""},
#     %{"date" => "2024-08-08", "time" => "15:30", "value" => ""},
#     %{"date" => "2024-08-08", "time" => "15:00", "value" => ""},
#     %{"date" => "2024-08-08", "time" => "14:30", "value" => ""}
#   ],
#   input_form: %{
#     "memo" => "あｘｃ",
#     "name" => "テスターA",
#     "pass" => "qaz",
#     "title" => "おためし"
#   }
#}




end #mod
