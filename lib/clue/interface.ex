defmodule Clue.Interface do
  use GenServer
  require Logger

  # External API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def write(msg) do
    GenServer.call(__MODULE__, {:write, msg})
  end

  def prompt(msg) do
    GenServer.call(__MODULE__, {:prompt, msg})
  end

  def handle_call({:write, msg}, _from, state) do
    IO.puts msg
    {:reply, {:ok}, state}
  end

  def handle_call({:prompt, msg}, _from, state) do
    response = IO.gets msg
    {:reply, response, state}
  end
end