class RemoveParentNodeIdToNodes < ActiveRecord::Migration[7.1]
  def change
    remove_column :nodes, :parent_node_id, :bigint
  end
end
