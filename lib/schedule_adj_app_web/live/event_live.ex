defmodule ScheduleAdjAppWeb.EventLive do
use  ScheduleAdjAppWeb, :live_view

def mount(_params, _session, socket) do
  {:ok, socket}
end

def render(assigns) do
  ScheduleAdjAppWeb.UserView.render("users.html", assigns)
end

end
