defmodule Clue.Initializer do
  use GenServer

  # External API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def setup do
    GenServer.call(__MODULE__, {:setup})
  end

  # GenServer Implementation

  def handle_call({:setup}, _from, state) do
    IO.puts "Welcome to Clue!"
    edition = IO.gets("Which edition are you using? > ") |> String.trim
    IO.puts "You entered #{edition}"
    Clue.EditionValidator.load_edition(edition)
    {:reply, {:ok}, state}
  end

end