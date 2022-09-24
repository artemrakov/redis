defmodule Parser do
  def parse(data) do
    info = String.split(data, "/r/n")
    extract_commands(info)
  end

  def extract_commands([_ | []]) do
    {"", []}
  end

  def extract_commands([_ | items]) do
    [[_, command] | args_with_data] = Enum.chunk_every(items, 2)
    args = Enum.map(args_with_data, fn [_, arg] -> arg end)

    {command, args}
  end
end