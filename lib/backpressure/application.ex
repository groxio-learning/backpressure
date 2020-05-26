defmodule Backpressure.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BackpressureWeb.Telemetry,
      {Backpressure.Worker, 0}, 
      # Start the PubSub system
      {Phoenix.PubSub, name: Backpressure.PubSub},
      # Start the Endpoint (http/https)
      BackpressureWeb.Endpoint
      # Start a worker by calling: Backpressure.Worker.start_link(arg)
      # {Backpressure.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Backpressure.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BackpressureWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
