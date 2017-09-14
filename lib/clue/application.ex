defmodule Clue.Application do
  use Application

  def start(_type, _args) do
    Clue.Supervisor.start_link
  end
end
