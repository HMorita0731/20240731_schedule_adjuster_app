defmodule ScheduleAdjAppWeb.EventController do
  use ScheduleAdjAppWeb, :controller

  # セッションにformの情報を登録する機能
  def next_page(conn, params) do
    # セッションにparamsを登録して次のページにリダイレクト
    conn
    |> put_session(:event, params)
    |> redirect(to: ~p"/event/new/date")
  end

  # next_page

  # IO.inspect(conn,label: "コネクション")
  # adapter: {Bandit.Adapter, :...},
  # assigns: %{flash: %{}},
  # body_params: %{
  #   "_csrf_token" => "MTokWDg0WH8NfwZ7KR8CPxxeHRs2fTUmTpPmhN00gIT2mhaz_kSppDxu",
  #   "input_form" => %{
  #     "memo" => "",
  #     "name" => "テスターA",
  #     "pass" => "qaz",
  #     "title" => "おためし"
  #   }
  # },
  # cookies: %{
  #   "_schedule_adj_app_key" => "SFMyNTY.g3QAAAABbQAAAAtfY3NyZl90b2tlbm0AAAAYZUp0NVB6aE9qNlJJRHdjRUM1TmtGOU1T.ip-Uu7HYdWdIE5pYubXl_ARfOa2S4ifK9zulKIU0gxY"
  # },
  # halted: false,
  # host: "localhost",
  # method: "POST",
  # owner: #PID<0.14300.0>,
  # params: %{
  #   "_csrf_token" => "MTokWDg0WH8NfwZ7KR8CPxxeHRs2fTUmTpPmhN00gIT2mhaz_kSppDxu",
  #   "input_form" => %{
  #     "memo" => "",
  #     "name" => "テスターA",
  #     "pass" => "qaz",
  #     "title" => "おためし"
  #   }
  # },
  # path_info: ["event", "new", "save"],
  # path_params: %{},
  # port: 4000,
  # private: %{
  #   :phoenix_view => %{
  #     "html" => ScheduleAdjAppWeb.EventHTML,
  #     "json" => ScheduleAdjAppWeb.EventJSON
  #   },
  #   ScheduleAdjAppWeb.Router => [],
  #   :phoenix_router => ScheduleAdjAppWeb.Router,
  #   :phoenix_endpoint => ScheduleAdjAppWeb.Endpoint,
  #   :plug_session_fetch => :done,
  #   :plug_session => %{"_csrf_token" => "eJt5PzhOj6RIDwcEC5NkF9MS"},
  #   :before_send => [#Function<0.98198498/1 in Plug.CSRFProtection.call/2>,
  #    #Function<4.23985858/1 in Phoenix.Controller.fetch_flash/2>,
  #    #Function<0.9035112/1 in Plug.Session.before_send/2>,
  #    #Function<0.54455629/1 in Plug.Telemetry.call/2>,
  #    #Function<1.66608267/1 in Phoenix.LiveReloader.before_send_inject_reloader/3>],
  #   :phoenix_request_logger => {"request_logger", "request_logger"},
  #   :phoenix_action => :next_page,
  #   :phoenix_layout => %{"html" => {ScheduleAdjAppWeb.Layouts, :app}},
  #   :phoenix_controller => ScheduleAdjAppWeb.EventController,
  #   :phoenix_format => "html",
  #   :phoenix_root_layout => %{"html" => {ScheduleAdjAppWeb.Layouts, :root}}
  # },
  # query_params: %{},
  # query_string: "",
  # remote_ip: {127, 0, 0, 1},
  # req_cookies: %{
  #   "_schedule_adj_app_key" => "SFMyNTY.g3QAAAABbQAAAAtfY3NyZl90b2tlbm0AAAAYZUp0NVB6aE9qNlJJRHdjRUM1TmtGOU1T.ip-Uu7HYdWdIE5pYubXl_ARfOa2S4ifK9zulKIU0gxY"
  # },
  # req_headers: [
  #   {"cookie",
  #    "_schedule_adj_app_key=SFMyNTY.g3QAAAABbQAAAAtfY3NyZl90b2tlbm0AAAAYZUp0NVB6aE9qNlJJRHdjRUM1TmtGOU1T.ip-Uu7HYdWdIE5pYubXl_ARfOa2S4ifK9zulKIU0gxY"},
  #   {"accept-language", "ja,en-US;q=0.9,en;q=0.8"},
  #   {"accept-encoding", "gzip, deflate, br, zstd"},
  #   {"referer", "http://localhost:4000/event/new"},
  #   {"sec-fetch-dest", "document"},
  #   {"sec-fetch-user", "?1"},
  #   {"sec-fetch-mode", "navigate"},
  #   {"sec-fetch-site", "same-origin"},
  #   {"accept",
  #    "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"},
  #   {"user-agent",
  #    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36"},
  #   {"content-type", "application/x-www-form-urlencoded"},
  #   {"origin", "http://localhost:4000"},
  #   {"upgrade-insecure-requests", "1"},
  #   {"sec-ch-ua-platform", "\"Windows\""},
  #   {"sec-ch-ua-mobile", "?0"},
  #   {"sec-ch-ua",
  #    "\"Not)A;Brand\";v=\"99\", \"Google Chrome\";v=\"127\", \"Chromium\";v=\"127\""},
  #   {"cache-control", "max-age=0"},
  #   {"content-length", "233"},
  #   {"connection", "keep-alive"},
  #   {"host", "localhost:4000"}
  # ],
  # request_path: "/event/new/save",
  # resp_body: nil,
  # resp_cookies: %{},
  # resp_headers: [
  #   {"cache-control", "max-age=0, private, must-revalidate"},
  #   {"x-request-id", "F-kOXGyMB0Sy9FMAAQEC"},
  #   {"referrer-policy", "strict-origin-when-cross-origin"},
  #   {"x-content-type-options", "nosniff"},
  #   {"x-download-options", "noopen"},
  #   {"x-frame-options", "SAMEORIGIN"},
  #   {"x-permitted-cross-domain-policies", "none"}
  # ],
  # scheme: :http,
  # script_name: [],
  # secret_key_base: :...,
  # state: :unset,
  # status: nil
  # }
end

# mod
