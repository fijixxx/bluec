defmodule Bluec.Subscriber do
  require Logger
  use Task

  def child_spec([boss: boss] = args) do
    %{
      id: {__MODULE__, boss},
      start: {__MODULE__, :start_link, [args]}
    }
  end

  def start_link(boss: boss) do
    Logger.info("#{boss} Subscriber up")

    search_path =
      case boss do
        "Shi" -> "Lv120 シヴァ"
        "Eur" -> "Lv120 エウロペ"
        "God" -> "Lv120 ゴッドガード・ブローディア"
        "Grim" -> "Lv120 グリームニル"
        "Met" -> "Lv120 メタトロン"
        "Ava" -> "Lv120 アバター"
      end

    Task.start_link(fn ->
      stream =
        ExTwitter.stream_filter(track: [search_path])
        # コンソールに1行ずつだす
        # |> Stream.map(fn _x -> IO.puts(NaiveDateTime.local_now() |> to_string) end)
        |> Stream.map(fn _x ->
          Agent.update(String.to_atom(boss), fn state ->
            [NaiveDateTime.local_now() |> to_string] ++ state
          end)
        end)

      # コンソールに Agent の中身を全部出力する(debug)
      # |> Stream.map(fn _x -> IO.puts(Agent.get(GBAgent, & &1)) end)

      Enum.to_list(stream)
    end)
  end

  def init(state), do: {:ok, state}
end
