# frozen_string_literal: true

require_relative './lib/binary_search_tree.rb'

# 1. Create a binary search tree from an array of random numbers
arr = Array.new(15) { rand(1..100) }

tree = Tree.new(arr)

# 2. Confirm that the tree is balanced by calling `#balanced?`
p tree.balanced?

# 3. Print out all elements in level, pre, post, and in order
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder

# 4. Unbalance the tree by adding several numbers > 100
10.times do |i|
  tree.insert(101 + i)
end

# 5. Confirm that the tree is unbalanced by calling `#balanced?`
p tree.balanced?

# 6. Balance the tree by calling `#rebalance!`
tree.rebalance!

# 7. Confirm that the tree is balanced by calling `#balanced?`
p tree.balanced?

# 8. Print out all elements in level, pre, post, and in order
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
