class AddUniqueConstraintToMazesName < ActiveRecord::Migration[7.1]
  def change
    add_index :mazes, :name, unique: true
  end
end
