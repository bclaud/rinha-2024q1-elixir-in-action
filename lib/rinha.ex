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

  def transaction(
        cliente_id,
        %{"valor" => valor, "tipo" => tipo, "descricao" => descricao} = request
      ) do
    %{limite: limite, saldo: saldo} = cliente = Rinha.Cliente.get_by_id(cliente_id)

    case valor <= limite do
      true ->
        Rinha.Extrato.update_statement(cliente_id, %{
          valor: valor,
          tipo: tipo,
          descricao: descricao,
          realizada_em: DateTime.utc_now()
        })

        Rinha.Cliente.update(cliente_id, %{cliente | saldo: saldo - valor})

        :ok

      false ->
        :bad_request
    end
  end

  def get_bank_statement(cliente_id) do
    %{transacoes: transacoes} = Rinha.Extrato.get_by_client_id(cliente_id)

    cliente = Rinha.Cliente.get_by_id(cliente_id)

    %{
      saldo: %{
        total: cliente.saldo,
        data_extrato: DateTime.utc_now(),
        limite: cliente.limite
      },
      ultimas_transacoes: Enum.take(transacoes, 10)
    }
  end

  def request_example() do
    %{"valor" => 10, "tipo" => "c", "descricao" => "descricao"}
  end
end

defmodule Rinha.Transacao do
  defstruct auto_id: 1, limite: 0, nome: nil, date: Date.utc_today()

  @type transacao :: %{id: pos_integer, limite: integer, nome: String.t(), date: Date.t()}
  @type t :: %__MODULE__{
          auto_id: pos_integer(),
          limite: integer,
          nome: String.t(),
          date: Date.t()
        }
end
