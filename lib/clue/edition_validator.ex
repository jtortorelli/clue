defmodule Clue.EditionValidator do
  use GenServer

  NimbleCSV.define(MyParser, [])

  @root_dir File.cwd!
  @editions_dir Path.join(~w(#{@root_dir} lib resources editions))

  # External API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def load_edition(name) do
    GenServer.call(__MODULE__, {:load_edition, name})
  end

  # GenServer Implementation

  def handle_call({:load_edition, name}, _from, state) do
    path = @editions_dir <> "/" <> name <> ".csv"
    IO.puts path
    if (File.exists?(path)) do
      IO.puts "file exists!"
    else
      IO.puts "file does not exist!"
    end
    {:reply, {:ok}, state}
  end
end