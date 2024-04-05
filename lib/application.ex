defmodule Golex.Application do
  use Application

  @impl true
  def start(_type, _args) do
    topologies = [
      golex: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: Golex.ClusterSupervisor]]},
      {Horde.Registry, [members: :auto, keys: :unique, name: Golex.CellRegistry]},
      Golex.HordeRegistry,
      Golex.HordeSupervisor,
      Golex.NodeObserver
    ]

    opts = [strategy: :one_for_one, name: Golex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
