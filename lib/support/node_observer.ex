defmodule Golex.NodeObserver do
  use GenServer

  require Logger
  alias Golex.{HordeRegistry, HordeSupervisor}

  def start_link(_), do: GenServer.start_link(__MODULE__, [])

  def init(_) do
    :net_kernel.monitor_nodes(true, node_type: :visible)

    {:ok, nil}
  end

  def handle_info({:nodeup, node, _node_type}, state) do
    set_members(HordeRegistry)
    set_members(HordeSupervisor)
    Logger.info("NEW NODE #{inspect(node)}")
    {:noreply, state}
  end

  def handle_info({:nodedown, _node, _node_type}, state) do
    set_members(HordeRegistry)
    set_members(HordeSupervisor)
    {:noreply, state}
  end

  defp set_members(name) do
    members = Enum.map([Node.self() | Node.list()], &{name, &1})
    :ok = Horde.Cluster.set_members(name, members)
  end
end
