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

