defmodule Rinha.System do
  def start_link do
    Supervisor.start_link(
      # TODO add GenServers
      [
        Rinha.Web,
        {Rinha.Extrato,
         %{
           1 => %{transacoes: []},
           2 => %{transacoes: []},
           3 => %{transacoes: []},
           4 => %{transacoes: []},
           5 => %{transacoes: []}
         }},
        {Rinha.Cliente,
         %{
           1 => %{id: 1, limite: 100_000, saldo: 0},
           2 => %{id: 2, limite: 80000, saldo: 0},
           3 => %{id: 3, limite: 1_000_000, saldo: 0},
           4 => %{id: 4, limite: 10_000_000, saldo: 0},
           5 => %{id: 5, limite: 500_000, saldo: 0}
         }}
      ],
      strategy: :one_for_one
    )
  end
end
