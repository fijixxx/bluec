defmodule Bluec.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    ExTwitter.configure(
      consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
      access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
    )

    children = [
      {Plug.Cowboy, scheme: :http, plug: Bluec.Router, options: [port: cowboy_port()]},
      {Bluec.State, []},
      {Bluec.Subscriber, []},
      {Bluec.Flusher, []}
      # Starts a worker by calling: Bluec.Worker.start_link(arg)
      # {Bluec.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bluec.Supervisor]

    Logger.info("App up")

    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:bluec, :cowboy_port, 8080)
end
