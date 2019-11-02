require "byebug"
require_relative "polyTreeNode"

class KnightPathFinder
  # minesweeper code
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

  def initialize(arr)
    @root_node = PolyTreeNode.new(arr)
    @considered_positions = [arr]
  end

  def find_path(target)
    build_move_tree(@root_node)

    # debugger
    target_node = @root_node.bfs(target)

    # debugger
    trace_path_back(target_node)

    # path_list
  end

  # use a queue to process nodes in FIFO order. Start with a root node representing
  # the start_pos and explore moves from one position at a time.

  # Next build nodes representing positions one move away, add these to the queue.
  # Then take the next node from the queue... until the queue is empty.
  def build_move_tree(startingNode)
    # debugger
    # queque_positions
    # starting_node_moves behaves as Queque

    queue = [startingNode]

    until queue.empty?
      node = queue.shift
      node_moves = new_move_positions(node.value)

      until node_moves.empty?
        pos = node_moves.shift

        node_child = PolyTreeNode.new(pos)
        node.add_child(node_child)

        queue.push(node_child)
      end

      # debugger
    end

    # queque_children_nodes = []

  end

  #   minesweeper code
  def valid_moves(pos)
    # debugger
    # te nawiasy chyba zbędne, to mogą przypominać, o destrukturyzacji
    possible_coords = DELTAS.map do |(dx, dy)|
      [pos[0] + dx, pos[1] + dy]
    end

    possible_valid_coords = possible_coords.select do |row, col|
      [row, col].all? do |coord|
        coord.between?(0, 8)
      end
    end

    possible_valid_coords
  end

  #   it should call the ::valid_moves class method, but filter out any positions that are already in @considered_positions.
  def new_move_positions(pos)
    # debugger
    new_move_positions = valid_moves(pos).reject { |move| @considered_positions.include?(move) }
    @considered_positions.push(*new_move_positions)

    new_move_positions
  end

  def trace_path_back(node)
    # debugger
    path_list = [node.value]

    until node.parent.nil?
      path_list.push(node.parent.value)
      node = node.parent
    end

    # todo robić push zamiast unshift, a na końcu reverse
    path_list.reverse
  end
end
