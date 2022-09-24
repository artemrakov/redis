defmodule Handler do
  def handle({"PING", []}) do
    "PONG"
  end

  def handle({"PING", message}) do
    message
  end

  def handle({"ECHO", message}) do
    message
  end
end
