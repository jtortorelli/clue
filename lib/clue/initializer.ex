defmodule Clue.Initializer do
  use GenServer

  # External API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
    Clue.Interface.write("Welcome to Clue!")
    edition = Clue.Interface.prompt("Which edition are you using? > ")
    Clue.Interface.write("You entered #{edition}")
  end

end