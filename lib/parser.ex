defmodule Parser do
  def parse(data) do
    String.split(data, "\r\n", trim: true)
    |> extract_commands
  end

  def extract_commands(["*0" | []]) do
    {"", []}
  end

  def extract_commands([_ | items]) do
    [[_, command] | args_with_data] = Enum.chunk_every(items, 2)
    args = Enum.map(args_with_data, fn [_, arg] -> arg end)

    {String.downcase(command), args}
  end
end
