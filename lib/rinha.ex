defmodule Rinha do
  @moduledoc """
  Documentation for `Rinha`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Rinha.hello()
      :world

  """
  def hello do
    :world
  end

end

defmodule Rinha.Transacao do 
  defstruct auto_id: 1, limite: 0, nome: nil, date: Date.utc_today()

  @type transacao :: %{id: pos_integer, limite: integer, nome: String.t(), date: Date.t()}
  @type t :: %__MODULE__{auto_id: pos_integer(), limite: integer, nome: String.t(), date: Date.t()}

end


defmodule Rinha.Web do 
  use Plug.Router
  plug :match
  plug :dispatch

  def child_spec(_arg) do 
    Plug.Cowboy.child_spec(
      scheme: :http,
      options: [port: Application.get_env(:rinha, :rinha_http_port, 8000)],
      plug: __MODULE__
    )
  end

  # https://github.com/zanfranceschi/rinha-de-backend-2024-q1?tab=readme-ov-file#o-que-precisa-ser-feito
  post "/clientes/:id/transacoes" do 
    #TODO
    nil
  end

  # https://github.com/zanfranceschi/rinha-de-backend-2024-q1?tab=readme-ov-file#extrato
  get "/clientes/:id/extrato" do 
    #TODO

    nil
  end

  match _ do 
    Plug.Conn.send_resp(conn, 404, "not found")
  end
end


defmodule Rinha.System do 
  def start_link do 
    Supervisor.start_link(
      #TODO add GenServers
      [],
      strategy: :one_for_one
    )
  end
end
