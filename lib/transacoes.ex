defmodule Rinha.Transacoes do
  use Agent

  def start_link(initial_state) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def get_by_client_id(cliente_id) do
    Agent.get(__MODULE__, &Map.get(&1, cliente_id))
  end

  def get_all do
    Agent.get(__MODULE__, & &1)
  end

  def new_statement(cliente_id, new_statement) do
    Agent.update(__MODULE__, &Map.put_new(&1, cliente_id, new_statement))
  end

  def update_statement(cliente_id, new_transaction) do
    Agent.update(
      __MODULE__,
      &Map.update!(&1, cliente_id, fn transacoes -> [new_transaction | transacoes] end)
    )
  end
end
