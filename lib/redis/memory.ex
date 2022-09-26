defmodule Redis.Memory do
  @name :memory

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def init(state) do
    {:ok, state}
  end

  def get(key) do
    GenServer.call(@name, {:get, key})
  end

  def set(key, value, opts \\ []) do
    GenServer.call(@name, {:set, key, value, opts})
  end

  def set_options(key, ["px", value]) do
    interval = String.to_integer(value)
    IO.inspect(key)
    IO.inspect(interval)
    Process.send_after(self(), {:remove, key}, interval)
  end

  def handle_call({:set, key, value, opts}, _, state) do
    new_state = Map.put(state, key, value)

    opts
    |> Enum.chunk_every(2)
    |> Enum.each(fn opt -> set_options(key, opt) end)

    {:reply, "OK", new_state}
  end

  def handle_call({:get, key}, _, state) do
    {:reply, state[key], state}
  end

  def handle_cast({:remove, key}, _, state) do
    {_, new_state} = Map.pop(state, key)
    {:noreply, new_state}
  end
end
