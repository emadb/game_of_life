defmodule Golex.Cell do
  use GenServer, restart: :transient

  def start_link([coord]) do
    GenServer.start_link(__MODULE__, [coord], name: via_tuple(coord))
  end

  def init([coord]) do
    IO.inspect coord, label: "I"
    {:ok, coord}
  end

  def tick(coord) do
    GenServer.call(via_tuple(coord), :tick)
  end

  def handle_call(:tick, _from, state) do

    if count_neighbours(state) == 2 || count_neighbours(state) == 3 do
      {:reply, :ok, state}
    else
      IO.inspect state, label: "D"
      {:stop, :shutdown, :ok, state}
    end
  end

  def count_neighbours({x, y}) do
    [ {x-1, y}, {x+1, y}, {x-1, y-1}, {x-1, y+1}, {x+1, y-1}, {x+1, y+1}, {x, y-1}, {x, y+1}]
    |> Enum.reduce(0, fn coord, acc ->
      case Horde.Registry.lookup(Golex.CellRegistry, coord) do
        [{_pid, _}] -> acc + 1
        [] -> acc
      end
    end)
  end

  defp via_tuple(coord) do
    {:via, Horde.Registry, {Golex.CellRegistry, coord}}
  end
end
