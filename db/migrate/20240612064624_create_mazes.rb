# frozen_string_literal: true

class CreateMazes < ActiveRecord::Migration[7.1]
  def change
    create_table :mazes do |t|
      t.string :name, null: false
      t.jsonb :initial_coordinate
      t.jsonb :goal_coordinate

      t.timestamps
    end
  end
end
