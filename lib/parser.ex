defmodule Parser do
  def parse(data) do
    [type | items] = String.split(data, "\r\n", trim: true)
    extract_commands(String.first(type), String.last(type), items)
  end

  def extract_commands("*", _, items) do
    [[_, command] | args_with_data] = Enum.chunk_every(items, 2)
    args = Enum.map(args_with_data, fn [_, arg] -> arg end)

    {String.downcase(command), args}
  end

  def extract_commands(_, _, _) do
    {"", []}
  end
end
