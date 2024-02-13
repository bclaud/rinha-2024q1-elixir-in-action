defmodule Rinha.System do
  def start_link do
    Supervisor.start_link(
      # TODO add GenServers
      [Rinha.Web],
      strategy: :one_for_one
    )
  end
end
