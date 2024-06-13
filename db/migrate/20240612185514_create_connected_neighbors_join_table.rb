class CreateConnectedNeighborsJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :connected_neighbors, id: false do |t|
      t.bigint :node_id, null: false
      t.bigint :connected_neighbor_id, null: false
      t.index [:node_id, :connected_neighbor_id], unique: true
      t.index [:connected_neighbor_id, :node_id], unique: true
    end
  end
end
