defmodule Clue.EditionUtil do
  def format_name(name) do
    String.split(name, "_")
    |> Enum.map(fn n -> String.capitalize(n) end)
    |> Enum.join(" ")
  end

  # def sort_editions(editions) do
  #   editions
  #   |> Enum.filter(fn e -> String.downcase(e) !== "standard" end)
  #   |> Enum.sort
  #   |> Enum.into(["standard"])
  # end
end