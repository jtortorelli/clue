defmodule Clue.Application do
  use Application

  def start(_type, _args) do
    result = Clue.Supervisor.start_link
    Clue.Initializer.setup
    result
  end
end
