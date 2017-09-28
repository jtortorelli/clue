defmodule Clue.Application do
  use Application

  def start(_type, _args) do
    IO.puts "Welcome to Clue!"
    edition = Clue.EditionUtil.load_edition
    players = Clue.PlayerUtil.load_players
    {:ok, _pid} = Clue.PlayerRegistry.start_link
    Enum.each(players, fn p -> :ok = Clue.PlayerRegistry.create_player(p) end)
    :ok = Clue.PlayerRegistry.display_all_players
    {:ok, self()}
  end
end
