defmodule ScheduleAdjAppWeb.EventLive.AddDate do
  use  ScheduleAdjAppWeb, :live_view

  alias ScheduleAdjApp.Events #eventのDAO
  alias ScheduleAdjApp.Events.Event #eventスキーマファイル
  alias ScheduleAdjApp.Events.EventDate #eventdateスキーマファイル
  alias ScheduleAdjApp.Users #UserDao
  alias ScheduleAdjApp.Users.User #Userスキーマファイル
  alias Plug.Conn


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
   IO.inspect(socket.assigns.add_datetime)
    {:noreply, socket}
  end #handle_event
  # Parameters: %{"time" => "12:00", "value" => ""}

  #socketから時間(add_datetime)を削除する
  def handle_event("delete_time",params,socket) do
    new_add_datetime =
      socket.assigns.add_datetime -- [params]

    socket =
      socket
      |>assign(:add_datetime, new_add_datetime)
      IO.inspect(socket.assigns.add_datetime)

   {:noreply, socket}
  end #handle_event("delete_time")






end #mod
