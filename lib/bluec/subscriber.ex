defmodule Bluec.Subscriber do
  require Logger
  use Task

  def init(state), do: {:ok, state}

  def start_link(_state) do
    Logger.info("Subscriber up")

    Task.start_link(fn ->
      stream =
        ExTwitter.stream_filter(track: "Lv120 ゴッドガード・ブローディア")
        # コンソールに1行ずつだす
        # |> Stream.map(fn _x -> IO.puts(NaiveDateTime.local_now() |> to_string) end)
        |> Stream.map(fn _x ->
          Agent.update(GbAgent, fn state ->
            [NaiveDateTime.local_now() |> to_string] ++ state
          end)
        end)

      # コンソールに Agent の中身を全部出力する(debug)
      # |> Stream.map(fn _x -> IO.puts(Agent.get(GbAgent, & &1)) end)

      Enum.to_list(stream)
    end)
  end
end
