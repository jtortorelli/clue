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
    GenServer.call(__MODULE__, {:load_edition}, :infinity)
  end

  # GenServer Implementation

  def handle_call({:load_edition}, _from, state) do
    select_edition()
    {:reply, {:ok}, state}
  end

  defp select_edition do
    IO.puts("Select edition:")
    files = File.ls!(@editions_dir)
    |> Enum.map(fn f -> Path.basename(f, ".csv") end)
    |> Stream.with_index(1)
    |> Enum.to_list
    Enum.each(files, fn {f, i} -> IO.puts "#{i}. #{f}" end)
    parsedIndex = IO.gets("> ") |> String.trim |> Integer.parse
    num_files = Enum.count(files)
    case parsedIndex do
      {index, _remainder} when index <= num_files and index > 0 ->
        {file, _i} = Enum.at(files, index - 1)
        filename = @editions_dir <> "/" <> file <> ".csv"
        IO.puts("You selected #{filename}")
      _ ->
        IO.puts("You did not select a valid edition!")
        IO.puts("Please try again!")
        select_edition()
    end
  end
end