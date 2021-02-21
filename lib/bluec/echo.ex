defmodule Bluec.Echo do
  require Logger
  use Agent

  def init(state), do: {:ok, state}

  def start_link(_state) do
    Logger.info("Stream up")

    Task.start_link(fn ->
      stream =
        ExTwitter.stream_filter(track: "Lv120 ゴッドガード・ブローディア")
        |> Stream.map(fn x -> x.text end)
        # |> Stream.map(fn x -> IO.puts("#{x}\n") end)
        |> Stream.map(fn x -> Agent.update(GbAgent, fn state -> state ++ [x] end) end)
        |> Stream.map(fn _x -> IO.puts(Agent.get(GbAgent, & &1)) end)

      Enum.to_list(stream)
    end)
  end
end
