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

    boss_list = [
      "Shi",
      "Eur",
      "God",
      "Grim",
      "Met",
      "Ava"
    ]

    server = [
      {Plug.Cowboy, scheme: :http, plug: Bluec.Router, options: [port: cowboy_port()]}
    ]

    states = Enum.map(boss_list, fn x -> {Bluec.State, [boss: x]} end)
    subscribers = Enum.map(boss_list, fn x -> {Bluec.Subscriber, [boss: x]} end)

    flusheres = [
      {Bluec.Flusher, [bosses: boss_list]}
    ]

    children = server ++ states ++ subscribers ++ flusheres

    #   # Starts a worker by calling: Bluec.Worker.start_link(arg)
    #   # {Bluec.Worker, arg}
    # ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bluec.Supervisor]

    Logger.info("App up")

    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:bluec, :cowboy_port, 8080)
end
