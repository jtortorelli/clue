defmodule Clue.EditionUtil do
  alias Clue.Card

  NimbleCSV.define(MyParser, [])

  @root_dir File.cwd!
  @custom_editions_dir Path.join(~w(#{@root_dir} lib resources editions custom))

  def load_edition do
    case select_edition_again() do
      {:ok} ->
        nil
      {:error, message} ->
        IO.puts(message)
        load_edition()
    end
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
        {:ok}
      index ->
        case Integer.parse(index) do
          {i, _} when i <= num_files and i > 0 ->
            {_index, filename, display_name} = Enum.at(files, i - 1)
            IO.puts("You selected the #{display_name} edition!")
            {:ok}
          :error ->
            {:error, "You did not select a valid edition!\nPlease try again!"}
          _ ->
            {:error, "You did not select a valid edition!\nPlease try again!"}
        end
    end
  end

  defp read_edition_from_file(filename) do
    File.read!(filename)
    |> MyParser.parse_string
    |> Enum.map(fn [name, type] -> %Card{name: name, type: type} end)
    |> Enum.uniq
  end

  defp validate_edition_contents([_head | _tail] = edition) do
    number_of_cards = Enum.count(edition)
    has_correct_number_of_cards = number_of_cards == 21

    number_of_suspects = Enum.filter(edition, fn card -> card.type == Atom.to_string(:suspect) end)
    |> Enum.count
    has_correct_number_of_suspects = number_of_suspects == 6

    number_of_weapons = Enum.filter(edition, fn card -> card.type == Atom.to_string(:weapon) end)
    |> Enum.count
    has_correct_number_of_weapons = number_of_weapons == 6

    number_of_rooms = Enum.filter(edition, fn card -> card.type == Atom.to_string(:room) end)
    |> Enum.count
    has_correct_number_of_rooms = number_of_rooms == 9

    cond do
      has_correct_number_of_cards and has_correct_number_of_suspects and has_correct_number_of_weapons and has_correct_number_of_rooms ->
        {:ok, edition}
      not has_correct_number_of_cards ->
        {:error, "Edition does not have correct number of cards! Expected: 21, Found: #{number_of_cards}"}
      not has_correct_number_of_suspects ->
        {:error, "Edition does not have correct number of suspects! Expected: 6, Found: #{number_of_suspects}"}
      not has_correct_number_of_weapons ->
        {:error, "Edition does not have correct number of weapons! Expected: 6, Found: #{number_of_weapons}"}
      not has_correct_number_of_rooms ->
        {:error, "Edition does not have correct number of rooms! Expected: 9, Found: #{number_of_rooms}"}
    end
  end
end