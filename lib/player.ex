defmodule Clue.Player do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def add_card(player, card) do
    GenServer.cast(player, {:add_card, card})
  end

  def get_cards(player) do
    GenServer.call(player, {:get_cards})
  end

  def set_number_of_cards(player, number_of_cards) do
    GenServer.cast(player, {:set_number_of_cards, number_of_cards})
  end

  def get_number_of_cards(player) do
    GenServer.call(player, {:get_number_of_cards})
  end

  def init(:ok) do
    cards = MapSet.new
    number_of_cards = 0
    {:ok, {cards, number_of_cards}}
  end

  def handle_cast({:add_card, card}, {cards, number_of_cards}) do
    {:noreply, {MapSet.put(cards, card), number_of_cards}}
  end

  def handle_cast({:set_number_of_cards, number_of_cards}, {cards, _}) do
    {:noreply, {cards, number_of_cards}}
  end

  def handle_call({:get_cards}, _from, {cards, _} = state) do
    {:reply, {:ok, cards}, state}
  end

  def handle_call({:get_number_of_cards}, _from, {_, number_of_cards} = state) do
    {:reply, {:ok, number_of_cards}, state}
  end
end