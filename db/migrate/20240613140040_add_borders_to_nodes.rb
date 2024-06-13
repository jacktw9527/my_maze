class AddBordersToNodes < ActiveRecord::Migration[7.1]
  def change
    add_column :nodes, :borders, :jsonb
  end
end
