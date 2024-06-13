class CreateNeighborsJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :neighbors, id: false do |t|
      t.bigint :node_id, null: false
      t.bigint :neighbor_id, null: false
      t.index [:node_id, :neighbor_id], unique: true
      t.index [:neighbor_id, :node_id], unique: true
    end
  end
end
