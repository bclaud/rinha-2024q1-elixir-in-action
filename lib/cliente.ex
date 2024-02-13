defmodule Rinha.Cliente do
  use Agent

  def start_link(initial_state) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def get_by_id(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  def update(id, new_state) do
    Agent.update(__MODULE__, fn state -> %{state | id => new_state} end)
  end
end
