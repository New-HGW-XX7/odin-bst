class Node
  attr_reader :value
  attr_accessor :l_child, :r_child

  def initialize(value = nil, l_child = nil, r_child = nil)
    @value = value
    @l_child = l_child
    @r_child = r_child
  end
end

class Tree
  attr_reader :root
  def initialize(arr)
    @root = build_tree(arr)
  end

  def build_tree(arr, left = [], right = [])
    return arr if arr.length < 1

    node = Node.new(arr.delete(arr[arr.length/2]))
    puts "node: #{node} - value #{node.value}"

    arr.each { |el| el < node.value ? left << el : right << el }

    puts "left: #{left}"
    puts "right: #{right} \n\n"
    node.l_child = build_tree(left)
    node.l_child = nil if node.l_child == []
    node.r_child = build_tree(right)
    node.r_child = nil if node.r_child == []
    node
  end
end

tree = Tree.new([1, 2, 3, 4, 5])
p tree.root