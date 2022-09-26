defmodule Redis.Handler do
  alias Redis.Memory

  def handle({"ping", []}) do
    "PONG"
    |> success
  end

  def handle({"ping", message}) do
    message
    |> success
  end

  def handle({"echo", message}) do
    message
    |> success
  end

  def handle({"set", [key, value | opts]}) do
    Memory.set(key, value, opts)
    |> success
  end

  def handle({"get", [key]}) do
    Memory.get(key)
    |> success_or_null
  end

  def handle(data) do
    data
    |> failure
  end

  def success(data) do
    "+#{data}\r\n"
  end

  def failure(_) do
    "-ERR unknown command\r\n"
  end

  def success_or_null(nil) do
    "$-1\r\n"
  end

  def success_or_null(data) do
    success(data)
  end
end
