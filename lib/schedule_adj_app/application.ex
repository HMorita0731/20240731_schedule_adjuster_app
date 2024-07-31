defmodule ScheduleAdjApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ScheduleAdjAppWeb.Telemetry,
      ScheduleAdjApp.Repo,
      {DNSCluster, query: Application.get_env(:schedule_adj_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ScheduleAdjApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ScheduleAdjApp.Finch},
      # Start a worker by calling: ScheduleAdjApp.Worker.start_link(arg)
      # {ScheduleAdjApp.Worker, arg},
      # Start to serve requests, typically the last entry
      ScheduleAdjAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ScheduleAdjApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScheduleAdjAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
