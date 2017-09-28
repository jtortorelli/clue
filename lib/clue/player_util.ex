defmodule Clue.PlayerUtil do
  def load_players do
    case select_players() do
      {:ok, players} ->
        players
      {:error, message} ->
        IO.puts(message)
        load_players()
    end
  end

  defp select_players do
    players = select_number_of_players()
    |> get_player_info
    |> get_number_of_cards_per_player
    |> Enum.map(fn {name, num_of_cards} -> {String.to_atom(name), num_of_cards} end)
    {:ok, players}
  end

  defp select_number_of_players do
    IO.puts("Enter the number of players:")
    number_of_players = IO.gets("> ") |> String.trim
    case Integer.parse(number_of_players) do
      {n, _} when 6 >= n >= 3 ->
        IO.puts("You selected #{n} players!")
        n
      {n, _} ->
        IO.puts("You did not enter a valid number! Expected: 3..6, Found: #{n}")
        IO.puts("Please try again!")
        select_number_of_players()
      :error ->
        IO.puts("You did not enter a valid number!")
        IO.puts("Please try again!")
        select_number_of_players()
    end
  end

  defp get_player_name(i) do
    alpha_regex = ~r/^[A-Za-z]*$/
    IO.puts("Enter Player #{i}'s name:")
    name = IO.gets("> ") |> String.trim
    if (name =~ alpha_regex) do
      IO.puts("Player #{i}'s name is #{name}!")
      name
    else
      IO.puts("You did not enter a valid name!")
      IO.puts("Name must contain only alphabetical characters!")
      IO.puts("Please try again!")
      get_player_name(i)
    end
  end

  defp get_player_info(num) do
    Enum.map(1..num, fn i -> get_player_name(i) end)
  end

  defp get_number_of_cards_for_player(name) do
    IO.puts("How many cards does #{name} have?")
    num = IO.gets("> ") |> String.trim
    case Integer.parse(num) do
      {n, _} ->
        IO.puts("#{name} has #{num} cards!")
        n
      :error ->
        IO.puts("You did not enter a valid number!")
        IO.puts("Please try again!")
        get_number_of_cards_for_player(name)
    end
  end

  defp get_number_of_cards_per_player(names) do
    num_cards_per_player = Enum.map(names, fn n -> get_number_of_cards_for_player(n) end)
    case Enum.sum(num_cards_per_player) do
      18 ->
        IO.puts("Cards have successfully been assigned to players!")
        Enum.zip(names, num_cards_per_player)
      n ->
        IO.puts("Number of cards assigned is incorrect!")
        IO.puts("Expected: 18, Found: #{n}")
        IO.puts("Please try again!")
        get_number_of_cards_per_player(names)
    end
  end
end