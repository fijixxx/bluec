defmodule Bluec.State do
  require Logger
  use Agent

  def child_spec([boss: boss] = args) do
    %{
      id: {__MODULE__, boss},
      start: {__MODULE__, :start_link, [args]}
    }
  end

  def start_link(boss: boss) do
    Logger.info("#{boss} State up")
    Agent.start_link(fn -> [] end, name: String.to_atom(boss))
  end

  def init(boss), do: {:ok, boss}
end
