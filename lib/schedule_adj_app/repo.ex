defmodule ScheduleAdjApp.Repo do
  use Ecto.Repo,
    otp_app: :schedule_adj_app,
    adapter: Ecto.Adapters.Postgres
end
