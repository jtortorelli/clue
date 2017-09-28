defmodule Clue.Application do
  use Application

  def start(_type, _args) do
    IO.puts "Welcome to Clue!"
    edition = Clue.EditionUtil.load_edition
    players = Clue.PlayerUtil.load_players
    {:ok, self()}
  end
end
