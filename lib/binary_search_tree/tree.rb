# frozen_string_literal: true

require_relative './node.rb'

# Represents the tree
class Tree
  attr_accessor :root

  def initialize(arr)
    @root = build_tree(arr)
  end

  # Convert a value into a node and
  # Insert the node in the hash and returns that node
  def insert(value, cur = @root)
    return @root = Node.new(value) if @root.nil?
    raise StandardError, 'Value already exist' if value == cur.value

    if value < cur.value
      cur.left ? insert(value, cur.left) : cur.left = Node.new(value)
    elsif value > cur.value
      cur.right ? insert(value, cur.right) : cur.right = Node.new(value)
    end
  end

  # Accepts a value to be deleted and returns the deleted node
  def delete(value)
    # Get the node to be deleted
    node_to_delete = find(value)
    raise StandardError, 'Value does not exist' if node_to_delete.nil?

    # Get the left most node of right subtree
    right_subtree_left_most = left_most(@root.right)
    # Get the value of the left most node of the right subtree
    right_subtree_left_most_value = right_subtree_left_most.value
    # Delete the left most node of the right subtree
    delete_left_most(right_subtree_left_most)
    # Copy the value of left most node of the right subtree to the node to be deleted
    node_to_delete.value = right_subtree_left_most_value
    # Returns the value of the deleted node
    value
  end

  # Returns the node with the given value.
  def find(value)
    level_order { |cur| return cur if value == cur.value }
  end

  # Traverse the tree in breadth-first level order and yield each node to the provided block.
  # Returns an array of node values if no block is given.
  def level_order
    return nil if @root.nil?

    queue = [@root]
    values = []
    until queue.empty?
      cur = queue.shift
      block_given? ? yield(cur) : values << cur.value
      queue << cur.left unless cur.left.nil?
      queue << cur.right unless cur.right.nil?
    end
    values unless block_given?
  end

  # Inorder, preoder, postoder methods accepts a block
  # Each method traverse the tree in their respective depth-first order and yield each node to the provided block.
  # Returns an array of node values if no block is given
  def inorder(cur = @root, values = [], &block)
    return nil if @root.nil?

    inorder(cur.left, values, &block) unless cur.left.nil?
    block_given? ? block.call(cur) : values << cur.value
    inorder(cur.right, values, &block) unless cur.right.nil?
    values unless block_given?
  end

  def preorder(cur = @root, values = [], &block)
    return nil if @root.nil?

    block_given? ? block.call(cur) : values << cur.value
    preorder(cur.left, values, &block) unless cur.left.nil?
    preorder(cur.right, values, &block) unless cur.right.nil?
    values unless block_given?
  end

  def postorder(cur = @root, values = [], &block)
    return nil if @root.nil?

    postorder(cur.left, values, &block) unless cur.left.nil?
    postorder(cur.right, values, &block) unless cur.right.nil?
    block_given? ? block.call(cur) : values << cur.value
    values unless block_given?
  end

  # Accepts a node and returns the depth(number of levels) of that node
  def depth(target_node, cur = @root, cur_depth = 0)
    return nil if @root.nil? || target_node.nil?
    return cur_depth if cur == target_node

    cur = target_node.value < cur.value ? cur.left : cur.right
    cur_depth += 1
    depth(target_node, cur, cur_depth)
  end

  # Returns the height of a node
  def height(cur = @root)
    return -1 if cur.nil?

    left = height(cur.left)
    right = height(cur.right)
    left > right ? left + 1 : right + 1
  end

  # Check if the tree/subtree is balanced
  def balanced?(cur = @root)
    return true if @root.nil?

    left_height = height(cur.left)
    right_height = height(cur.right)
    diff = (left_height - right_height).abs
    diff < 2
  end

  # Rebalance tree
  def rebalance!
    return if balanced?

    @root = build_tree(level_order)
  end

  private

  # Takes an array of values and turns it into a balanced tree
  # Returns the root node
  def build_tree(arr)
    return nil if arr.empty?
    return Node.new(arr[0]) if arr.length < 2

    arr.sort.uniq
    mid = arr.length / 2
    node = Node.new(arr[mid]) # At first iteration this will be the root of the entire tree
    node.left = build_tree(arr[0..mid - 1]) # Get the left subtree
    node.right = build_tree(arr[mid + 1..-1]) # Get the right subtree
    node
  end

  # Returns the left most descendant of a node
  def left_most(node)
    cur = node
    cur = cur.left until cur.left.nil?
    cur
  end

  # Delete the left most descendant of a node
  def delete_left_most(node)
    tmp = @root
    level_order do |cur|
      break if tmp.left == node || tmp.right == node

      tmp = cur
    end
    if tmp.left == node
      tmp.left = nil
    elsif tmp.right == node
      tmp.right = nil
    end
  end
end
