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

  def set(key, value) do
    GenServer.call(@name, {:set, key, value})
  end

  def handle_call({:set, key, value}, _, state) do
    new_state = Map.put(state, key, value)
    {:reply, "OK", new_state}
  end

  def handle_call({:get, key}, _, state) do
    {:reply, state[key], state}
  end
end
