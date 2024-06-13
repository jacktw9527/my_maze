class RemoveInitialAndGoalCoordinatesFromMazes < ActiveRecord::Migration[7.1]
  def change
    remove_column :mazes, :initial_coordinate, :jsonb
    remove_column :mazes, :goal_coordinate, :jsonb
  end
end
