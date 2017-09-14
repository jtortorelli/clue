defmodule Clue.Supervisor do
  use Supervisor

  def start_link do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [])
    start_workers(sup)
    result
  end

  def start_workers(sup) do
    Supervisor.start_child(sup, worker(Clue.Initializer, []))
    Supervisor.start_child(sup, worker(Clue.EditionValidator, []))
    Clue.Initializer.setup
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end