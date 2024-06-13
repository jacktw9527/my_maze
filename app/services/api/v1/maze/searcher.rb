# frozen_string_literal: true

module Api::V1
  module Maze
    class Searcher
      # @param [String] name
      def execute(name)
        maze = ::Maze.find_by(name:)
        return { success: false, error_message: 'Maze not found' } if maze.blank?

        nodes_info = maze.nodes.map do |node|
          {
            position_x: node.position_x,
            position_y: node.position_y,
            width: node.width,
            height: node.height,
            color: node.color,
            ans_color: node.ans_color,
            borders: node.borders
          }
        end
        data = { nodes: nodes_info }
        { success: true, data: }
      end
    end
  end
end
