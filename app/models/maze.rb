# frozen_string_literal: true

class Maze < ApplicationRecord
  store_accessor :initial_coordinate, :initial_coordinate_x
  store_accessor :initial_coordinate, :initial_coordinate_y
  store_accessor :goal_coordinate, :goal_coordinate_x
  store_accessor :goal_coordinate, :goal_coordinate_y

  has_many :nodes, dependent: :destroy

  # version1: constant maze width and height
  HEIGHT = 500
  WIDTH = 500
end
