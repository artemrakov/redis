defmodule Redis.Server do
  use Supervisor

  alias Redis.Parser
  alias Redis.Handler

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      {Task, fn -> listen() end}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def listen() do
    {:ok, socket} = :gen_tcp.listen(6379, [:binary, active: false, reuseaddr: true])
    accept_loop(socket)
  end

  def accept_loop(listen_socket) do
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    Task.start(fn -> serve_loop(client_socket) end)
    accept_loop(listen_socket)
  end

  def serve_loop(listen_socket) do
    serve(listen_socket)
    serve_loop(listen_socket)
  end

  def serve(client_socket) do
    client_socket
    |> read_request
    |> Parser.parse()
    |> Handler.handle()
    |> write_response(client_socket)
  end

  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)

    request
  end

  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)
  end
end
