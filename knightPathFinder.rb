require "byebug"
require_relative "polyTreeNode"

class KnightPathFinder
  # minesweeper inspired-code
  attr_reader :root_node

  DELTAS = [
    [1, -2],  # top-right
    [-1, -2], # top-left
    [2, 1], # right-top
    [2, -1], # right-bottom
    [1, 2], # bottom-right
    [-1, 2], # bottom-left
    [-2, -1], # left-top
    [-2, 1],  # left-bottom
  ].freeze

  #   static method
  def self.valid_moves(pos)
    possible_coords = DELTAS.map do |(dx, dy)|
      [pos[0] + dx, pos[1] + dy]
    end

    possible_valid_coords = possible_coords.select do |(row, col)|
      [row, col].all? do |coord|
        coord.between?(0, 8)
      end
    end

    possible_valid_coords
  end

  def initialize(arr)
    @root_node = PolyTreeNode.new(arr)
    @considered_positions = [arr]
  end

  def find_path(target)
    build_move_tree

    target_node = @root_node.bfs(target)

    trace_path_back(target_node)
  end

  private_constant :DELTAS

  private

  def build_move_tree
    queue = [@root_node]

    until queue.empty?
      node = queue.shift
      node_moves = new_move_positions(node.value)

      node_moves.each do |node_move|
        node_child = PolyTreeNode.new(node_move)
        node.add_child(node_child)

        queue.push(node_child)
      end
    end
  end

  def new_move_positions(pos)
    KnightPathFinder.valid_moves(pos)
                    .reject { |move| @considered_positions.include?(move) }
                    .each { |move| @considered_positions.push(move) }
  end

  def trace_path_back(node)
    path_list = [node.value]

    until node.parent.nil?
      path_list << node.parent.value
      node = node.parent
    end

    path_list.reverse
  end
end
