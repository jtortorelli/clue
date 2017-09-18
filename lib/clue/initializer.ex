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

  def handle_call({:setup}, _from, state) do
    IO.puts "Welcome to Clue!"
    Clue.EditionUtil.load_edition
    {:reply, {:ok}, state}
  end

end