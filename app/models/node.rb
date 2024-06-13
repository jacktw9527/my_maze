# frozen_string_literal: true

# A node is a cell in the maze
class Node < ApplicationRecord
  store_accessor :coordinate, :coordinate_x
  store_accessor :coordinate, :coordinate_y
  store_accessor :position, :position_x
  store_accessor :position, :position_y
  store_accessor :borders, :top
  store_accessor :borders, :bottom
  store_accessor :borders, :left
  store_accessor :borders, :right

  attr_writer :visited, :explored

  belongs_to :maze
  has_and_belongs_to_many :neighbors,
                          class_name: 'Node',
                          join_table: 'neighbors',
                          foreign_key: 'node_id',
                          association_foreign_key: 'neighbor_id'
  has_and_belongs_to_many :connected_neighbors,
                          class_name: 'Node',
                          join_table: 'connected_neighbors',
                          foreign_key: 'node_id',
                          association_foreign_key: 'connected_neighbor_id'

  enum color: {
    LightGray: 0, # default node color
    DodgerBlue: 1, # entry node color
    Tomato: 2 # exit node color
  }

  enum ans_color: {
    LightGrey: 0, # default node color, similar to color LightGray
    MediumSeaGreen: 1, # solve solution color
    LightSkyBlue: 2, # entry node color
    Orange: 3 # exit node color
  }

  SIZE = 25

  def visited
    @visited ||= false
  end

  def explored
    @explored ||= false
  end
end
