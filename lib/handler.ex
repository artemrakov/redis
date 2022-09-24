defmodule Handler do
  def handle({"ping", []}) do
    "PONG"
  end

  def handle({"ping", message}) do
    message
  end

  def handle({"echo", message}) do
    message
  end
end
