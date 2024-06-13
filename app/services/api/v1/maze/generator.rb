# frozen_string_literal: true

module Api::V1
  module Maze
    class Generator
      # @param [String] name
      def execute(name)
        maze =
          ActiveRecord::Base.transaction do
            maze = ::Maze.create!(name:)
            matrix = init_nodes!(maze)
            define_node_neighbors(matrix)
            generate_random_path(maze)
            generate_entry_exit_nodes(maze)
            search_shortest_path(maze)
            maze
          end

        { success: true, data: maze_data(maze) }
      rescue ActiveRecord::RecordNotUnique => _e
        { success: false, error_message: 'Maze name duplicate' }
      rescue StandardError => _e
        { success: false, error_message: 'Generate maze failed' }
      end

      private

      def init_nodes!(maze)
        x = 0
        matrix = []
        (0...::Maze::WIDTH).step(Node::SIZE).each do |pos_x|
          matrix << []
          (0...::Maze::HEIGHT).step(Node::SIZE).each do |pos_y|
            node = maze.nodes.new(position_x: pos_x, position_y: pos_y, width: Node::SIZE, height: Node::SIZE)
            # initialize node.node_borders
            node.top = { color: 'Black' }
            node.bottom = { color: 'Black' }
            node.left = { color: 'Black' }
            node.right = { color: 'Black' }
            node.save!
            matrix[x] << node
          end
          x += 1
        end
        matrix
      end

      def define_node_neighbors(matrix)
        (0...::Maze::COORDINATE_X_MAX).each do |i|
          (0...::Maze::COORDINATE_Y_MAX).each do |j|
            node = matrix[i][j]
            node.coordinate_x = i
            node.coordinate_y = j
            if i.positive? && j.positive? && i < ::Maze::COORDINATE_X_MAX - 1 && j < ::Maze::COORDINATE_Y_MAX - 1
              node.neighbors << matrix[i + 1][j] # bot
              node.neighbors << matrix[i - 1][j] # top
              node.neighbors << matrix[i][j + 1] # right
              node.neighbors << matrix[i][j - 1] # left
            elsif i.zero? && j.zero?
              node.neighbors << matrix[i][j + 1] # right
              node.neighbors << matrix[i + 1][j] # bot
            elsif i == ::Maze::COORDINATE_X_MAX - 1 && j.zero?
              node.neighbors << matrix[i - 1][j] # top
              node.neighbors << matrix[i][j + 1] # right
            elsif i.zero? && j == ::Maze::COORDINATE_Y_MAX - 1
              node.neighbors << matrix[i][j - 1] # left
              node.neighbors << matrix[i + 1][j] # bot
            elsif i == ::Maze::COORDINATE_X_MAX - 1 && j == ::Maze::COORDINATE_Y_MAX - 1
              node.neighbors << matrix[i][j - 1] # left
              node.neighbors << matrix[i - 1][j] # top
            elsif j.zero?
              node.neighbors << matrix[i - 1][j] # top
              node.neighbors << matrix[i][j + 1] # right
              node.neighbors << matrix[i + 1][j] # bot
            elsif i.zero?
              node.neighbors << matrix[i + 1][j] # bot
              node.neighbors << matrix[i][j + 1] # right
              node.neighbors << matrix[i][j - 1] # left
            elsif i == ::Maze::COORDINATE_X_MAX - 1
              node.neighbors << matrix[i - 1][j] # top
              node.neighbors << matrix[i][j + 1] # right
              node.neighbors << matrix[i][j - 1] # left
            elsif j == ::Maze::COORDINATE_Y_MAX - 1
              node.neighbors << matrix[i + 1][j] # bot
              node.neighbors << matrix[i - 1][j] # top
              node.neighbors << matrix[i][j - 1] # left
            end
            node.save!
          end
        end
      end

      def generate_random_path(maze)
        # Preload neighbors to avoid N+1 queries
        maze.nodes.includes(:neighbors).each do |node|
          node.visited = false
        end

        # dfs generate random path
        current_node = maze.nodes.sample
        current_node.visited = true
        stack = [current_node]
        visited_nodes_count = 1
        while visited_nodes_count != maze.total_nodes_count || !stack.empty?
          remove_visited_neighbors(current_node)

          if current_node.neighbors.count.positive?
            random_neighbor = current_node.neighbors.sample
            remove_wall(current_node, random_neighbor)
            add_connected_neighbors(current_node, random_neighbor)
            current_node.save!
            random_neighbor.save!

            current_node = random_neighbor
            stack.append(current_node)
            current_node.visited = true
            visited_nodes_count += 1
          elsif stack.length == 1
            stack.pop
          else
            stack.pop
            current_node = stack[-1]
          end
        end
      end

      def remove_visited_neighbors(node)
        node.neighbors = node.neighbors.select { |neighbor| neighbor.visited == false }
      end

      def remove_wall(node, neighbor)
        # right
        if (neighbor.coordinate_x == node.coordinate_x + 1) && (neighbor.coordinate_y == node.coordinate_y)
          node.right['color'] = 'LightGray'
          neighbor.left['color'] = 'LightGray'
        # left
        elsif (neighbor.coordinate_x == node.coordinate_x - 1) && (neighbor.coordinate_y == node.coordinate_y)
          node.left['color'] = 'LightGray'
          neighbor.right['color'] = 'LightGray'
        # bot
        elsif (neighbor.coordinate_x == node.coordinate_x) && (neighbor.coordinate_y == node.coordinate_y + 1)
          node.bottom['color'] = 'LightGray'
          neighbor.top['color'] = 'LightGray'
        # top
        elsif (neighbor.coordinate_x == node.coordinate_x) && (neighbor.coordinate_y == node.coordinate_y - 1)
          node.top['color'] = 'LightGray'
          neighbor.bottom['color'] = 'LightGray'
        end
      end

      def add_connected_neighbors(node, neighbor)
        neighbor.connected_neighbors << node
        node.connected_neighbors << neighbor
      end

      def generate_entry_exit_nodes(maze)
        entry_node = maze.border_nodes.sample
        exit_node = maze.border_nodes.sample
        exit_node = maze.border_nodes.sample while entry_node == exit_node
        entry_node.update!(color: 'DodgerBlue', ans_color: 'LightSkyBlue')
        exit_node.update!(color: 'Tomato', ans_color: 'Orange')
      end

      def search_shortest_path(maze)
        entry_node = maze.nodes.find_by(color: 'DodgerBlue')
        exit_node = maze.nodes.find_by(color: 'Tomato')
        entry_node.explored = true
        find = false
        queue = [entry_node]
        nodes_with_neighbors = maze.nodes.includes(:connected_neighbors).index_by(&:id)

        parent_list = {}

        while queue.length.positive? && !find
          search_node = queue.shift
          nodes_with_neighbors[search_node.id].connected_neighbors.each do |connected_neighbor|
            next if connected_neighbor.explored

            parent_list[connected_neighbor.id] = search_node
            connected_neighbor.explored = true
            queue << connected_neighbor
            find = true if connected_neighbor == exit_node
          end
        end

        # colorful shortest path
        current = exit_node
        while parent_list[current.id].present?
          current = parent_list[current.id]
          break if current.id == entry_node.id

          current.update!(ans_color: 'MediumSeaGreen')
        end
      end

      def maze_data(maze)
        nodes_info = maze.nodes.reload.map do |node|
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
        { nodes: nodes_info }
      end
    end
  end
end
