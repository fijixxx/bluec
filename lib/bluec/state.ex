defmodule Bluec.State do
  require Logger
  use Agent

  def init(state), do: {:ok, state}

  def start_link(state \\ []) do
    Logger.info("State up")
    Agent.start_link(fn -> state end, name: GbAgent)
  end
end
