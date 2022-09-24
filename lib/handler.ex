defmodule Handler do
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

  def handle(data) do
    data
    |> failure
  end

  def success(data) do
    "+#{data}\r\n"
  end

  def failure(data) do
    "-ERR unknown command #{data}\r\n"
  end
end
