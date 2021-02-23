defmodule Bluec.Flusher do
  require Logger
  use Task

  def init(state), do: {:ok, state}

  def start_link(_state) do
    Logger.info("Flusher up")
    ticker("")
  end

  defp ticker(date) do
    task = Task.async(fn -> Logger.info(date) end)
    Task.await(task)
    new_date = NaiveDateTime.local_now() |> to_string |> String.split(" ")

    unless(hd(new_date) == date) do
      flusher()
    end

    :timer.sleep(180_000)
    ticker(hd(new_date))
  end

  defp flusher do
    Logger.info("Flush")
    Agent.update(GbAgent, fn _x -> [""] end)
  end
end
