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

  def transaction(cliente_id, _) when cliente_id > 5, do: {:error, :not_found}

  def transaction(cliente_id, request) do
    case Rinha.TransactionLock.check(cliente_id) do
      false ->
        Rinha.TransactionLock.acquire(cliente_id)
        result = do_transaction(cliente_id, request)
        Rinha.TransactionLock.release(cliente_id)

        result

      true ->
        Process.sleep(50)
        transaction(cliente_id, request)
    end
  end

  def do_transaction(
        cliente_id,
        %{"valor" => valor, "tipo" => tipo, "descricao" => descricao} = _request
      ) do
    %{limite: limite, saldo: saldo} = cliente = Rinha.Cliente.get_by_id(cliente_id)

    case valor <= limite do
      true ->
        novo_saldo = saldo - valor

        Rinha.Transacoes.update_statement(cliente_id, %{
          valor: valor,
          tipo: tipo,
          descricao: descricao,
          realizada_em: DateTime.utc_now()
        })

        Rinha.Cliente.update(cliente_id, %{cliente | saldo: novo_saldo})

        {:ok, %{limite: limite, saldo: novo_saldo}}

      false ->
        {:error, :bad_request}
    end
  end

  def get_bank_statement(cliente_id) when cliente_id > 5, do: {:error, :not_found}

  def get_bank_statement(cliente_id) do
    transacoes = Rinha.Transacoes.get_by_client_id(cliente_id)

    case Rinha.Cliente.get_by_id(cliente_id) do
      nil ->
        {:error, :not_found}

      cliente ->
        {:ok,
         %{
           saldo: %{
             total: cliente.saldo,
             data_extrato: DateTime.utc_now(),
             limite: cliente.limite
           },
           ultimas_transacoes: Enum.take(transacoes, 10)
         }}
    end
  end

  def request_example() do
    %{"valor" => 10, "tipo" => "c", "descricao" => "descricao"}
  end
end

defmodule Rinha.TransactionLock do
  use Agent

  def start_link(initial_state \\ %{}) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def acquire(id) do
    Agent.update(__MODULE__, &Map.put(&1, id, true))
  end

  def release(id) do
    Agent.update(__MODULE__, &Map.put(&1, id, false))
  end

  def check(id) do
    Agent.get(__MODULE__, &Map.get(&1, id), :infinity)
  end
end
