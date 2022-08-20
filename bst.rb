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
  
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.r_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.r_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.l_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.l_child
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

  def insert(value)
    cur = self.root
    prev = nil
    until cur.nil?
      if value < cur.value
        prev = cur
        cur = cur.l_child
      else
        prev = cur
        cur = cur.r_child
      end
    end
    p cur = Node.new(value)
    cur.value < prev.value ? prev.l_child = cur : prev.r_child = cur
  end
end

tree = Tree.new([1, 3, 4, 6, 7, 8, 9])
tree.pretty_print
tree.insert(5)
tree.pretty_print