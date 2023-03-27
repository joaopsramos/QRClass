defmodule QRClass.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      QRClassWeb.Telemetry,
      # Start the Ecto repository
      QRClass.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: QRClass.PubSub},
      # Start Finch
      {Finch, name: QRClass.Finch},
      # Start the Endpoint (http/https)
      QRClassWeb.Endpoint
      # Start a worker by calling: QRClass.Worker.start_link(arg)
      # {QRClass.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QRClass.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QRClassWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
