defmodule Bluec.Subscriber do
  require Logger
  use Task

  def start_link(bosses: bosses) do
    Logger.info("Subscriber up")

    search_words = [
      Shi: "Lv120 シヴァ",
      Eur: "Lv120 エウロペ",
      God: "Lv120 ゴッドガード・ブローディア",
      Grim: "Lv120 グリームニル",
      Met: "Lv120 メタトロン",
      Ava: "Lv120 アバター"
    ]

    search_paths = Enum.map(bosses, fn x -> search_words[String.to_atom(x)] end)

    Task.start_link(fn ->
      stream =
        ExTwitter.stream_filter(track: search_paths)
        |> Stream.map(fn x -> matcher(x.text) end)

      Enum.to_list(stream)
    end)
  end

  defp matcher(txt) do
    type =
      cond do
        String.contains?(txt, "Lv120 シヴァ") -> :Shi
        String.contains?(txt, "Lv120 エウロペ") -> :Eur
        String.contains?(txt, "Lv120 ゴッドガード・ブローディア") -> :God
        String.contains?(txt, "Lv120 グリームニル") -> :Grim
        String.contains?(txt, "Lv120 メタトロン") -> :Met
        String.contains?(txt, "Lv120 アバター") -> :Ava
      end

    Agent.update(type, fn state ->
      [NaiveDateTime.local_now() |> to_string] ++ state
    end)
  end

  def init(state), do: {:ok, state}
end
