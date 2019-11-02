require "byebug"

class PolyTreeNode
  attr_reader :parent, :children, :value

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(parent_node)
    return if parent_node == parent

    if parent_node.nil?
      @parent = nil
      return
    end

    # TODO safe navigation &.
    # sytuacja zmiany rodzica dla danego wezła powoduje konieczność aktualizacji
    # informacji o powiązaniu dotychczasowego (ex) rodzica z bieżącym węzłem
    unless parent.nil?
      parent.children.delete(self)
    end

    @parent = parent_node
    parent_node.children << self
  end

  def add_child(child_node)
    child_node.parent = self unless child_node.nil?
  end

  def add_children(children_nodes)
    children_nodes.each { |node| node.parent = self unless node.nil? }
  end

  def remove_child(child_node)
    if children.include?(child_node)
      child_node.parent = nil
    else
      raise "No such child node as #{child_node}"
    end
  end

  # takes a value to search for and performs the search.
  def dfs(target_value)
    return self if self.value == target_value

    # return self if target_value == value

    children.each do |node|
      result = node.dfs(target_value)
      return result unless result.nil?
    end

    nil

    # First, check the value at this node. If a node's value matches the target value, return the node.
    # If not, iterate through the #children and repeat.
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      node = queue.shift

      return node if node.value == target_value

      queue.push(*node.children)
      #  nodes.concat(node.children)
    end

    nil
    # You will use a local Array variable as a queue to implement this.
    # First, insert the current node (self) into the queue.
    # Then, in a loop that runs until the array is empty:
    # Remove the first node from the queue,
    # Check its value,
    # Push the node's children to the end of the array.
  end

  def inspect
    if @parent.nil?
      return { value: @value,
               parent: "root" }
    end
    { value: @value,
     parent: { value: @parent.value } }
  end
end
