defmodule Server do
  use Application

  def start(_type, _args) do
    Supervisor.start_link([{Task, fn -> Server.listen() end}], strategy: :one_for_one)
  end

  def listen() do
    IO.puts("Logs from your program will appear here!")

    {:ok, socket} = :gen_tcp.listen(6379, [:binary, active: false, reuseaddr: true])
    accept(socket)
  end

  def accept(listen_socket) do
    IO.puts "Waiting for client connection"

    {:ok, client} = :gen_tcp.accept(listen_socket)
    serve(client)
  end

  def serve(client_socket) do
    client_socket
    |> read_request
    |> handle
    |> serialze
    |> write_response(client_socket)
  end

  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)

    request
  end

  def handle(_request) do
    "PONG"
  end

  def serialze(response) do
    "+#{response}\r\n"
  end

  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)
  end
end
