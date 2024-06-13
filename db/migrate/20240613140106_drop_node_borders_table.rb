class DropNodeBordersTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :node_borders
  end
end
