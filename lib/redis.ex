defmodule Redis do
  use Application

  def start(_type, _args) do
    Redis.Supervisor.start_link()
  end
end
