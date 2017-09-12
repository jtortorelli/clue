defmodule Clue.Initializer do
  use GenServer

  # External API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def setup do
    GenServer.call(__MODULE__, {:setup}, :infinity)
  end

  # GenServer Implementation

  def init(state) do
    Process.send_after(self(), {:setup}, 1000)
    {:ok, state}
  end

  def handle_call({:setup}, _from, state) do
    IO.puts "Welcome to Clue!"
    Clue.EditionValidator.load_edition
    {:reply, {:ok}, state}
  end

end