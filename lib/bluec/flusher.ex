defmodule Bluec.Flusher do
  require Logger
  use Task

  # def init(state), do: {:ok, state}

  def start_link(bosses: bosses) do
    Logger.info("Flusher up")
    ticker("", bosses)
  end

  defp ticker(date, bosses) do
    new_date = NaiveDateTime.local_now() |> to_string |> String.split(" ")

    unless(hd(new_date) == date) do
      flusher(bosses)
    end

    :timer.sleep(180_000)
    ticker(hd(new_date), bosses)
  end

  defp flusher(bosses) do
    Logger.info("Flush")
    Enum.all?(bosses, fn x -> Agent.update(String.to_atom(x), fn _x -> [""] end) end)
    # Agent.update(:GB, fn _x -> [""] end)
    # Agent.update(:Gr, fn _x -> [""] end)
  end
end
