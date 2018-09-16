
class Edge
  attr_reader :src
  attr_reader :dst
  attr_reader :weight
  def initialize(src,dst,weight)
    @src = src
    @dst = dst
    @weight = weight
  end
  def to_s
    "(N: " + @dst.to_s + " W: " + @weight.to_s + ")"
  end
end
  
class Node
  attr_reader :name
  attr_reader :successors
  attr_reader :predecessors

  def initialize(name)
    @name = name
    @successors = []
    @predecessors = []
  end

  def add_predecessor(predecessor)
    @predecessors << predecessor
  end

  def remove_predecessort(name)
    @predecessors -= [name]
  end

  def add_edge(successor)
    @successors << successor
  end

  def remove_edge(name)
    @successors -= [name]
  end

  def n_of_edges
    @successors.length
  end

  def [](position)
    @successors[position]
  end

  def include?(name)
    @successors.any? {|x| x.dst == name }
  end
  
  def select(name)
    @successors.select {|s| s.dst == name}
  end

  def select_candidates(explored)
    return @successors.select {|item|
                !explored.include?(item.successor_name)
           }
  end

  def sample
    @successors.sample(1).first
  end

  def to_s
    "#{@name.to_s} -> [#{@successors.join(' ')}]"
  end
end
  
class Graph
  attr_reader :nodes
  attr_reader :edges
  
  def initialize
    @nodes = {}
    @edges = []
  end

  def add_node(node)
    @nodes[node.name] = node if !@nodes.include?(node.name)
  end

  def contains(name,other_name)
      @nodes[name].include?(other_name)
  end

  def edge(name,other_name)
    @nodes[name].select(other_name)
  end
  
  def edges(name,other_name)
    @edges
  end
  
  def successors(name)
    @nodes[name].successors
  end

  def predecessors(name)
    @nodes[name].predecessors
  end

  def remove_node(contains)
      @nodes.delete(node_name)
  end

  def add_edge(edge)
    @nodes[edge.src].add_edge(edge)
    @nodes[edge.dst].add_predecessor(edge)
    @edges.push(edge)
  end

  def remove_edge(edge)
    @nodes[edge.src].remove_edge(edge)
    @nodes[edge.dst].remove_predecessor(edge)
    @edges.remove(edge)
  end

  def [](name)
    @nodes[name]
  end

  def size
      @nodes.length
  end

  def empty?
    @nodes.length == 0
  end

  def n_of_nodes
    @nodes.length
  end

  def to_s
    "Graph"
  end
end
