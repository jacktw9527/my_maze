# frozen_string_literal: true

# A maze is a collection of nodes
class Maze < ApplicationRecord
  has_many :nodes, dependent: :destroy

  # version1: constant maze width and height
  HEIGHT = 500
  WIDTH = 500
  COORDINATE_X_MAX = (HEIGHT / Node::SIZE).to_i.freeze
  COORDINATE_Y_MAX = (WIDTH / Node::SIZE).to_i.freeze

  def total_nodes_count
    @total_nodes_count ||= nodes.count
  end

  def border_nodes
    @border_nodes ||=
      nodes.select do |node|
        node.coordinate_x.zero? || node.coordinate_x == Maze::COORDINATE_X_MAX - 1 ||
          node.coordinate_y.zero? || node.coordinate_y == Maze::COORDINATE_Y_MAX - 1
      end
  end
end
