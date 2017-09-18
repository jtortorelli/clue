defmodule Clue.EditionUtil do

  NimbleCSV.define(MyParser, [])

  @root_dir File.cwd!
  @custom_editions_dir Path.join(~w(#{@root_dir} lib resources editions custom))

  def load_edition do
    select_edition_again()
  end

  defp format_name(name) do
    String.split(name, "_")
    |> Enum.map(fn n -> String.capitalize(n) end)
    |> Enum.join(" ")
  end

  defp select_edition_again do
    IO.puts("Select edition (press ENTER for standard edition):")

    files = File.ls!(@custom_editions_dir)
    |> Stream.with_index(1)
    |> Enum.to_list
    |> Enum.map(fn {filename, index} -> {index, filename, (Path.basename(filename, ".csv") |> format_name) } end)

    Enum.each(files, fn {index, _filename, display_name} -> IO.puts "#{index}. #{display_name}" end)

    parsed_index = IO.gets("> ") |> String.trim

    num_files = Enum.count(files)

    case parsed_index do
      "" ->
        # return standard edition
        IO.puts("You selected the standard edition!")
      index ->
        case Integer.parse(index) do
          {i, _} when i <= num_files and i > 0 ->
            {_index, filename, display_name} = Enum.at(files, i - 1)
            IO.puts("You selected the #{display_name} edition!")
          _ ->
            IO.puts("You did not select a valid edition!")
            IO.puts("Please try again!")
            select_edition_again()
        end
    end
  end
end