defmodule Golex.LocalNodeDistribution do
  @behaviour Horde.DistributionStrategy

  @moduledoc """
  Distributes processes to nodes uniformly using a hash ring
  """

  def choose_node(_identifier, _members) do
    {:ok,
     %Horde.DynamicSupervisor.Member{
       status: :alive,
       name: {Golex.HordeSupervisor, Node.self()}
     }}
  end

  def has_quorum?(_members), do: true
end
