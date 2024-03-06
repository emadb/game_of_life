defmodule Golex.Application do
  use Application

  @impl true
  def start(_type, _args) do

    topologies = [
      example: [
        strategy: Cluster.Strategy.Gossip,
        config: [hosts: [:"node_1@127.0.0.1", :"node_2@127.0.0.1"]],
      ]
    ]
    children = [
      {Cluster.Supervisor, [topologies, [name: Golex.ClusterSupervisor]]},
      {Horde.Registry, [members: :auto, keys: :unique, name: Golex.CellRegistry]},
      Golex.HordeRegistry,
      Golex.HordeSupervisor,
      Golex.NodeObserver,
    ]

    opts = [strategy: :one_for_one, name: Golex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
