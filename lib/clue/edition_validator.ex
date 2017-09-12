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
    check_file_exists()
    {:reply, {:ok}, state}
  end

  defp check_file_exists do
    edition = IO.gets("Which edition are you using? > ") |> String.trim
    IO.puts "You entered #{edition}"
    path = @editions_dir <> "/" <> edition <> ".csv"
    if (File.exists?(path)) do
      IO.puts "Edition found!"
    else
      IO.puts "Edition not found! Please try again!"
      check_file_exists()
    end
  end
end