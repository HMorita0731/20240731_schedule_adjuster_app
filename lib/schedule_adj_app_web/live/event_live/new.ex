defmodule ScheduleAdjAppWeb.EventLive.New do
  use ScheduleAdjAppWeb, :live_view

  # eventのDAO
  alias ScheduleAdjApp.Events
  # eventスキーマファイル
  alias ScheduleAdjApp.Events.Event
  # eventdateスキーマファイル
  alias ScheduleAdjApp.Events.EventDate
  # UserDao
  alias ScheduleAdjApp.Users
  # Userスキーマファイル
  alias ScheduleAdjApp.Users.User

  # イベント作成画面/機能
  # def render(assigns) do
  #   ~H"""

  #   """
  # end render

  # 関数
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  # mount

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # handle

  # 『phx-change="validate"』のvalidate作る関数
  # params = %{"event" => %{"_unused_memo" => "", "_unused_name" => "", "_unused_pass" => "", "memo" => "", "name" => "", "pass" => "", "title" => "新歓イベント"}}
  def handle_event("validate", %{"input_form" => params}, socket) do
    cs = Events.change_event(socket.assigns.event, params)
    {:noreply, assign_form(socket, cs)}
  end

  # handle_event(バグらせないための一時的な処理)

  # 入力情報一時保存
  def handle_event("next_page", %{"input_form" => params}, socket) do
    event_changeset = Events.change_event(%Event{}, params)
    user_changeset = Users.change_user_for_event_insert(%User{}, params)

    if event_changeset.valid? && user_changeset.valid? do
      socket =
        socket
        # 2つのcsをセッションに保存
        |> assign(trigger_submit: true)

      {:noreply, socket}
    else
      # どっちのエラーの情報も持ったフォーム構造体を作りたい
      return_form = to_form(event_changeset, as: "input_form")
      # error情報同士ををくっつける
      return_form =
        %{
          return_form
          | errors: return_form.errors ++ return_form.source.errors ++ user_changeset.errors
        }

      socket =
        socket
        |> assign(:form, return_form)
        |> put_flash(:error, "必須項目を入力してください")

      # error出さないための戻り値
      {:noreply, socket}
    end

    # if
  end

  # handle_event("next_page")

  # IO.inspect(params)
  # Parameters: %{"event" => %{"date" => "2024-08-03", "memo" => "備考欄にかいたこと", "name" => "だれか", "pass" => "aaa", "time" => "17:30", "title" => "新歓イベント"}}
  # %{
  #   "event" => %{
  #     "memo" => "備考欄にかいたこと",
  #     "name" => "だれか",
  #     "pass" => "aaa",  #     "title" => "新歓イベント"
  #   }

  # イベント新規作成アクション:new
  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{})
    |> assign_form(Events.change_event(%Event{}))
  end

  # apply

  # ソケットにcsをフォーム型にして挿入
  defp assign_form(socket, cs) do
    assign(socket, :form, to_form(cs, as: "input_form"))
  end

  # assign_form
end

# mod
