
class Edge
  attr_reader :src
  attr_reader :dst
  attr_accessor :weight
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
    @successors = {}
    @predecessors = []
  end

  def add_predecessor(predecessor)
    @predecessors << predecessor
  end

  def remove_predecessor(name)
    @predecessors -= [name]
  end

  def add_edge(successor)
    @successors[successor.dst] = successor 
  end

  def remove_edge(name)
    @successors.delete(name)
  end

  def n_of_edges
    @successors.length
  end

  def include?(name)
    @successors.include?(name)
  end
  
  def select(name)
    @successors[name]
  end

  def select_candidates(explored)
    return @successors.values.select {|item|
                !explored.include?(item.dst)
           }
  end

  def sample
    @successors.to_a.sample(1).first
  end

  def to_s
    "#{@name.to_s} -> [#{@successors.to_s}]"
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
  
  def successors(name)
    @nodes[name].successors
  end

  def predecessors(name)
    @nodes[name].predecessors
  end

  def remove_node(name)
      @nodes.delete(name)
  end

  def add_edge(edge)
    @nodes[edge.src].add_edge(edge)
    @nodes[edge.dst].add_predecessor(edge)
    @edges.push(edge)
  end

  def remove_edges(node_name)
    for edge in @edges
      if (edge.src  == node_name || edge.dst == node_name)
        @nodes[edge.src].remove_edge(edge) if @nodes.include?(edge.src)
        @nodes[edge.dst].remove_predecessor(edge) if @nodes.include?(edge.dst)
      end
    end 
    @edges.delete_if{|e| e.src  == node_name || e.dst == node_name } 
  end

  def reweight_edges(weights)
    for edge in edges
        edge.weight = edge.weight + weights[edge.src] - weights[edge.dst]
    end 
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
