defmodule Bluec.Fetcher do
  require Logger

  def today do
    today = Agent.get(GbAgent, & &1)
    count = (Enum.count(today) - 1) |> to_string
    count
  end

  def now do
    today = Agent.get(GbAgent, & &1)
    count = Enum.filter(today, fn x -> now_filter(x) > 0 end) |> Enum.count() |> to_string
    count
  end

  defp now_filter(datetime) do
    point = NaiveDateTime.local_now() |> NaiveDateTime.add(-600, :second) |> to_string

    if datetime > point do
      1
    else
      0
    end
  end
end
