# frozen_string_literal: true

class Node < ApplicationRecord
  store_accessor :coordinate, :coordinate_x
  store_accessor :coordinate, :coordinate_y
  store_accessor :position, :position_x
  store_accessor :position, :position_y
  attr_accessor :visited, :explored

  belongs_to :maze
  has_many :node_borders, dependent: :destroy
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
  belongs_to :parent_node, class_name: 'Node', optional: true

  enum color: {
    gray: 0,
    green: 1 # solve solution color
  }

  SIZE = 25

  before_destroy :handle_child_nodes

  private

  def handle_child_nodes
    # Set parent_id to nil for all child nodes before destroying the parent node
    Node.where(parent_node_id: id).update_all(parent_node_id: nil)
  end
end
