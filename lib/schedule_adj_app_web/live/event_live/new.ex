defmodule ScheduleAdjAppWeb.EventLive.New do
    use  ScheduleAdjAppWeb, :live_view

    alias ScheduleAdjApp.Events #eventのDAO
    alias ScheduleAdjApp.Events.Event #eventスキーマファイル
    alias ScheduleAdjApp.Events.EventDate #eventdateスキーマファイル
    alias ScheduleAdjApp.Users #UserDao
    alias ScheduleAdjApp.Users.User #Userスキーマファイル


# イベント作成画面/機能
  # def render(assigns) do
  #   ~H"""

  #   """
  # end render

  #関数
  def mount(_params, _session, socket) do
    socket =
     socket
     |>assign(:trigger_submit, false)
    {:ok, socket}
  end #mount

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end #handle

  #『phx-change="validate"』のvalidate作る関数
  def handle_event("validate", %{"input_form" => params}, socket) do
    cs = Events.change_event(socket.assigns.event, params)
    {:noreply, assign_form(socket, cs)}
  end #handle_event(バグらせないための一時的な処理)

  # 入力情報一時保存
  def handle_event("next_page",%{"input_form" => params},socket) do
    IO.inspect(params)
    event_changeset = Events.change_event(%Event{}, params)
    user_changeset = Users.change_user_for_event_insert(%User{}, params)
    IO.inspect(event_changeset)
    IO.inspect(user_changeset)
    IO.inspect(socket,label: "ソケット")

    #セッション保存用チェンジセット用意
    socket =
      case event_changeset.valid?  do
        true ->
          socket
          |>assign(:event_changeset, event_changeset)
        false ->
          socket
          |>assign(:event_changeset, event_changeset)

    end #case event_changeset

    socket=
      case user_changeset.valid? do
        true ->
          socket
          |>assign(:user_changeset, user_changeset)
        false ->
          socket
          |>assign(:user_changeset, user_changeset)

    end #case user_changeset

    if socket.assigns.event_changeset.valid? && socket.assigns.user_changeset.valid? do
      socket =
      socket
       |>assign(trigger_submit: true)
      IO.inspect(socket.assigns)
       {:noreply, socket}
    else #仮で書いているだけ
      socket=
      socket
       |>put_flash(:error, "必須項目を入力してください")
      {:noreply, socket} #error出さないための戻り値
    end #if

  end #handle_event("next_page")

  #saveアクション(transactionで全部dbに入れる)
  def handle_event("save",%{"event" => params},socket) do
    %{"date" => date,"time" => time} = params
    datetime = convert_datetime(date, time)
    params =
      Map.merge(params,%{"event_dates" => datetime})
    socket =
      case Events.insert_form(params)|>IO.inspect() do
        {:ok,transaction} ->
          socket
          |> put_flash(:info, "新しいイベントを登録しました")


        {:error,action,_ ,_ } -> #引数の数4かも
          socket
          |> put_flash(:error, "#{action}で登録に失敗しました")
    end #case

    {:noreply, socket}
  end #handle_event

  # IO.inspect(params)
  # Parameters: %{"event" => %{"date" => "2024-08-03", "memo" => "備考欄にかいたこと", "name" => "だれか", "pass" => "aaa", "time" => "17:30", "title" => "新歓イベント"}}
  # %{
  #   "event" => %{
  #     "memo" => "備考欄にかいたこと",
  #     "name" => "だれか",
  #     "pass" => "aaa",  #     "title" => "新歓イベント"
  #   }

  # イベント登録関数
  defp save_event(socket, :new, params) do
    case Events.create_event(params) do
    {:ok, event} ->
          socket
          |>put_flash(:info, "作成成功です")
          |> redirect(to: ~p"/event/show/#{event}")
    {:error, cs} ->
          assign_form(socket, cs)
    end #case

  end #save_event

  # イベント新規作成アクション:new
  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{})
    |> assign_form(Events.change_event(%Event{}))
  end #apply

  # ソケットにcs型挿入
  defp assign_form(socket, cs) do
    assign(socket, :form, to_form(cs,as: "input_form"))
  end #assign_form

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
#end #convert_from_datetime

end #mod
