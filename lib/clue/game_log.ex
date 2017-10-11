defmodule Clue.GameLog do
  use GenServer
  alias Clue.Card

  @root_dir File.cwd!
  @logs_dir Path.join(~w(#{@root_dir} lib resources logs))

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def log_event(event) do
    GenServer.call(__MODULE__, {:log_event, event})
  end

  def print_log() do
    GenServer.call(__MODULE__, {:print_log})
  end

  def write_log() do
    GenServer.call(__MODULE__, {:write_log})
  end

  def handle_call({:log_event, %{player: player, action: action, cards: %{suspect: %Card{} = suspect, room: %Card{} = room, weapon: %Card{} = weapon}}}, _from, state) do
    log = case action do
      :suggestion ->
        "#{player} made a suggestion: #{suspect.name}, #{room.name}, #{weapon.name}"
      :suggestion_pass ->
        "#{player} passed on a suggestion: #{suspect.name}, #{room.name}, #{weapon.name}"
      :suggestion_show ->
        "#{player} showed on a suggestion: #{suspect.name}, #{room.name}, #{weapon.name}"
      :accusation ->
        "#{player} made an accusation: #{suspect.name}, #{room.name}, #{weapon.name}"
      :accusation_fail ->
        "#{player}'s accusation failed: #{suspect.name}, #{room.name}, #{weapon.name}"
      :accusation_success ->
        "#{player}'s accusation succeeded: #{suspect.name}, #{room.name}, #{weapon.name}"
    end
    {:reply, :ok, state ++ [log]}
  end

  def handle_call({:log_event, %{player: player, action: action, card: %Card{} = card}}, _from, state) do
    log = case action do
      :has_card ->
        "#{player} has card: #{card.name}"
    end
    {:reply, :ok, state ++ [log]}
  end

  def handle_call({:print_log}, _from, state) do
    Enum.each(state, fn log -> IO.puts("#{inspect log}") end)
    {:reply, :ok, state}
  end

  def handle_call({:write_log}, _from, state) do
    current_timestamp = Timex.now |> DateTime.to_string
    filename = @logs_dir <> "/clue_game_log_#{current_timestamp}.txt" |> String.replace(" ", "_")
    {:ok, file} = File.open filename, [:write, :utf8]
    content = Enum.join(state, "\n")
    IO.write file, content
    {:reply, :ok, state}
  end
end