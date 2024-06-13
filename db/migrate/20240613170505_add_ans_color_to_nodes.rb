class AddAnsColorToNodes < ActiveRecord::Migration[7.1]
  def change
    add_column :nodes, :ans_color, :integer, default: 0
  end
end
