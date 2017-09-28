defmodule Clue.Supervisor do
  use Supervisor

  def start_link do
    {:ok, _pid} = Supervisor.start_link(__MODULE__, [])
  end

  def start_workers(sup) do
    Supervisor.start_child(sup, worker(Clue.Initializer, []))
  end

  def init(_) do
    child_processes = [worker(Clue.Initializer, [])]
    supervise child_processes, strategy: :one_for_one
  end
end