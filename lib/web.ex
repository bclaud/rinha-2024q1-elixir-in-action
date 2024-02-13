defmodule Rinha.Web do
  use Plug.Router
  plug(:match)
  plug(:dispatch)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  def child_spec(_arg) do
    Plug.Cowboy.child_spec(
      scheme: :http,
      options: [port: Application.get_env(:rinha, :rinha_http_port, 9999)],
      plug: __MODULE__
    )
  end

  # https://github.com/zanfranceschi/rinha-de-backend-2024-q1?tab=readme-ov-file#o-que-precisa-ser-feito
  post "/clientes/:id/transacoes" do
    request = conn.body_params
    id = String.to_integer(id)

    case Rinha.transaction(id, request) do
      {:ok, response} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(response))

      {:error, :bad_request} ->
        conn
        |> send_resp(422, "limite insuficiente")

      {:error, :not_found} ->
        conn
        |> send_resp(404, "not found")
    end
  end

  # https://github.com/zanfranceschi/rinha-de-backend-2024-q1?tab=readme-ov-file#extrato
  get "/clientes/:id/extrato" do
    case Rinha.get_bank_statement(String.to_integer(id)) do
      {:ok, extrato} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(extrato))

      {:error, _} ->
        conn
        |> send_resp(404, "not found")
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
