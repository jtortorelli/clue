defmodule Clue.PlayerRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def create_player({player_name, num_of_cards}) do
    GenServer.call(__MODULE__, {:create_player, player_name, num_of_cards})
  end

  def display_all_players() do
    GenServer.call(__MODULE__, {:display_all_players})
  end

  def handle_call({:create_player, player_name, num_of_cards}, _from, state) do
    {:ok, _player_pid} = Clue.Player.start_link(player_name)
    Clue.Player.set_number_of_cards(player_name, num_of_cards)
    {:reply, :ok, [player_name | state]}
  end

  def handle_call({:display_all_players}, _from, state) do
    state
    |> Enum.map(fn player_name ->
      {:ok, player_info} = Clue.Player.get_player_info(player_name)
      player_info
    end)
    |> Scribe.print



    {:reply, :ok, state}
  end
end