defmodule Bluec.Subscriber do
  require Logger
  use Task

  def init(state), do: {:ok, state}

  def start_link(_state) do
    Logger.info("Subscriber up")

    Task.start_link(fn ->
      stream =
        ExTwitter.stream_filter(track: "Lv120 ゴッドガード・ブローディア")
        |> Stream.map(fn _x ->
          Agent.update(GbAgent, fn state -> [NaiveDateTime.local_now() |> to_string] ++ state end)
        end)

      # |> Stream.map(fn _x -> IO.puts(Agent.get(GbAgent, & &1)) end)

      Enum.to_list(stream)
    end)
  end
end
