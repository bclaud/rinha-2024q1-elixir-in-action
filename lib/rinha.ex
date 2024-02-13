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
  @type t :: %__MODULE__{
          auto_id: pos_integer(),
          limite: integer,
          nome: String.t(),
          date: Date.t()
        }
end
