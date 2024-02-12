defmodule Rinha.Application do 
  use Application 

  @impl true
  def start(_, _) do
    Rinha.System.start_link()
  end

end

