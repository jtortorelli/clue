defmodule Clue.PlayerTest do
  use ExUnit.Case

  setup context do
    {:ok, player} = Clue.Player.start_link(context.test)
    {:ok, player: player}
  end

  test "initializes with no cards", %{player: player} do
    {:ok, cards} = Clue.Player.get_cards(player)
    assert Enum.empty?(cards)
  end

  test "initializes with zero number of cards", %{player: player} do
    {:ok, number_of_cards} = Clue.Player.get_number_of_cards(player)
    assert 0 = number_of_cards
  end

  test "adds card", %{player: player} do
    Clue.Player.add_card(player, "card")
    {:ok, cards} = Clue.Player.get_cards(player)
    assert MapSet.member?(cards, "card")
  end

  test "sets number of cards", %{player: player} do
    Clue.Player.set_number_of_cards(player, 1)
    {:ok, number_of_cards} = Clue.Player.get_number_of_cards(player)
    assert 1 = number_of_cards
  end
end