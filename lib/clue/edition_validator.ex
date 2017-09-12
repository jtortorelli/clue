defmodule Clue.EditionValidator do
  use GenServer

  NimbleCSV.define(MyParser, [])

  @root_dir File.cwd!
  @editions_dir Path.join(~w(#{@root_dir} lib resources editions))

  # External API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def load_edition do
    GenServer.call(__MODULE__, {:load_edition})
  end

  # GenServer Implementation

  def handle_call({:load_edition}, _from, state) do
    edition = IO.gets("Which edition are you using? > ") |> String.trim
    IO.puts "You entered #{edition}"
    path = @editions_dir <> "/" <> edition <> ".csv"
    IO.puts path
    if (File.exists?(path)) do
      IO.puts "file exists!"
      {:reply, {:ok}, state}
    else
      IO.puts "file does not exist!"
      {:reply, {:error}, state}
    end
  end
end