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
  attr_reader :root, :length
  def initialize(arr)
    @length = arr.length
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

  def traverse_and_map(node = root, result = [])
    if node.nil?
      return
    else
      result << node.value
    end
    result << traverse_and_map(node.l_child) 
    result << traverse_and_map(node.r_child)
    result.flatten.compact
  end

  def insert(value)
    cur = root
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
    cur = Node.new(value)
    cur.value < prev.value ? prev.l_child = cur : prev.r_child = cur
  end

  def delete(value)
    cur = root
    prev = nil
    until cur.value == value
      if value < cur.value
        prev = cur
        cur = cur.l_child
      else
        prev = cur
        cur = cur.r_child
      end
    end
    p cur
    case
    # If node is a leaf
    when cur.l_child.nil? && cur.r_child.nil? then prev.l_child == cur ? prev.l_child = nil : prev.r_child = nil
    # If node has one child
    when cur.l_child.nil? then prev.l_child == cur ? prev.l_child = cur.r_child : prev.r_child = cur.r_child
    when cur.r_child.nil? then prev.l_child == cur ? prev.l_child = cur.l_child : prev.r_child = cur.l_child
    # If node has two children and right child is a leaf
    when cur.r_child.l_child.nil? && cur.r_child.r_child.nil?
      cur.r_child.l_child = cur.l_child
      prev.l_child == cur ? prev.l_child = cur.r_child : prev.r_child = cur.r_child
    # If node has two children and right child is not a leaf
    when cur.r_child.l_child.nil? == false || cur.r_child.r_child.nil? == false
      prev.l_child == cur ? prev.l_child = cur.r_child : prev.r_child = cur.r_child

      temp = traverse_and_map(cur.l_child)
      temp.each { |el| self.insert(el) }
    end
  end

  def find(value)
    cur = root
    until cur.value == value
      if value < cur.value
        cur = cur.l_child
      else
        cur = cur.r_child
      end
    end
    cur
  end

  def level_order(&block)
    values = []
    q = [root]
    until q.empty?
      block.call(q.first) if block_given?
      values << q.first.value
      q << q.first.l_child unless q.first.l_child.nil?
      q << q.first.r_child unless q.first.r_child.nil?
      q.shift
    end
    p values if !block_given?
  end

  def level_order_rec(q = [root], values = [], &block)
    return if q.empty?
    block.call(q.first) if block_given?
    values << q.first.value
    q << q.first.l_child unless q.first.l_child.nil?
    q << q.first.r_child unless q.first.r_child.nil?
    q.shift
    values << level_order_rec(q, &block)
    p values.flatten.compact if !block_given?
  end

  def preorder(node = root, &block)
    puts node.value
    block.call(node) if block_given?
    return if node.l_child.nil? && node.r_child.nil?
    preorder(node.l_child, &block)
    preorder(node.r_child, &block)
  end

  def inorder(node = root, &block)
    if block_given?
      return block.call(node) if node.l_child.nil? && node.r_child.nil?
      inorder(node.l_child, &block)
      block.call(node)
      inorder(node.r_child, &block)
    else
      return node.value if node.l_child.nil? && node.r_child.nil?
      puts inorder(node.l_child)
      puts node.value
      puts inorder(node.r_child)
    end
  end
end

tree = Tree.new([1, 3, 5, 7, 8, 9, 10])

tree.pretty_print
#tree.level_order { |node| puts node.value }
#tree.level_order_rec { |node| puts node.value }
#tree.preorder { |node| puts node.value * 100 }
tree.inorder #{ |node| puts node.value * 10 }