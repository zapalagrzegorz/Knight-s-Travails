require "byebug"
require_relative "polyTreeNode"

class KnightPathFinder
  # minesweeper code
  attr_reader :root_node
  # [
  # [0,0], [0,1], [0,2]
  # [1,0], [1,1], [1,2]
  # [2,0], [2,1]
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

  def initialize(arr)
    @root_node = PolyTreeNode.new(arr)
    @considered_positions = [arr]
  end

  def find_path(target)
    build_move_tree(@root_node)

    return_list = @root_node.bfs(target)
    debugger

    next_node_in_path = return_list[-1]
    path_list = [next_node_in_path.value]

    until next_node_in_path.value == @root_node.value
      index_previous_node = return_list.find_index { |node| node.value == next_node_in_path.parent.value }
      next_node_in_path = return_list[index_previous_node]
      path_list.unshift(next_node_in_path.value)
    end

    path_list
  end

  def build_move_tree(startingNode)
    # debugger
    starting_node_moves = new_move_positions(startingNode.value)

    unless starting_node_moves.empty?
      polyNodes = starting_node_moves.map do |pos|
        PolyTreeNode.new(pos)
      end

      startingNode.add_children(polyNodes)

      polyNodes.each { |node| build_move_tree(node) }
    end
  end

  #   minesweeper code
  def valid_moves(pos)
    # te nawiasy chyba zbędne, to mogą przypominać, o destrukturyzacji
    possible_coords = DELTAS.map do |(dx, dy)|
      [pos[0] + dx, pos[1] + dy]
    end

    possible_valid_coords = possible_coords.select do |row, col|
      [row, col].all? do |coord|
        coord.between?(0, 8)
      end
    end
  end

  #   it should call the ::valid_moves class method, but filter out any positions that are already in @considered_positions.
  def new_move_positions(pos)
    new_move_positions = valid_moves(pos).reject { |move| @considered_positions.include?(move) }
    @considered_positions.push(*new_move_positions)

    new_move_positions
  end
end
