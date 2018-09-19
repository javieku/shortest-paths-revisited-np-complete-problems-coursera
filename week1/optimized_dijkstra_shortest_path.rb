require_relative 'common'
require_relative 'graph'
require_relative 'heap'
require 'set'

class ExtendedNode
  attr_reader :node
  attr_reader :weight
  def initialize(node,weight)
    @node = node
    @weight = weight
  end
end

class DijktraAlgorithm
  attr_reader :shortest_path
  def initialize
    @shortest_path = {}
  end

  def execute graph, initial_node

    minheap = Heap.new { |x, y| (x.weight <=> y.weight) == -1 }
    
    graph.nodes.each do |node|
      @shortest_path[node.first] = 0.0
      edge = graph.edge(initial_node,node.first);
      minheap.push(ExtendedNode.new(node.first,edge.weight)) if node.first != initial_node && edge != nil
    end
    
    explored = Set[initial_node]
    while(explored.length != graph.nodes.size)
      
      ext = minheap.pop
      
      while (ext && explored.include?(ext.node))
        puts(ext.node)
        puts(ext.weight)
        puts(minheap.next.node)
        puts(minheap.next_key.node)
        puts(minheap.empty?)
        puts "JAVI! " + minheap.size.to_s
        minheap.delete(ext.node)
        ext = minheap.pop
      end
    
      if (!ext)
        unreachable_nodes = (explored.to_a - graph.nodes.keys) | (graph.nodes.keys - explored.to_a)
        for v in unreachable_nodes
          @shortest_path[v] = FIXNUM_MAX
        end
        break;
      end

      @shortest_path[ext.node] = ext.weight
      explored.add(ext.node)

      graph.successors(ext.node).each do |node|

        if(explored.include?(node.first))
          next
        end
        if(node.first == 599)
          puts "JAVI! " + minheap.size.to_s
        end
        edge = graph.edge(ext.node,node.first);
        minheap.push(ExtendedNode.new(node.first, ext.weight + edge.weight))
      end
    end
  end

  def to_s 
    result = ""
    @shortest_path.each do |item|
      result += "--[#{item[1].to_s}]--> #{item[0].to_s}  # "
    end
    result
  end
end

def main
  start = Time.now
  graph = GraphLoader.instance.read_graph "g_dijkstra.txt"
  puts "Graph loaded in memory " +  (Time.now - start).to_s
  start = Time.now
  puts "Starting Dijkstra's algorithm"
  dijkstra = DijktraAlgorithm.new
  initial_node = 1
  dijkstra.execute(graph, initial_node) 
  puts "Dijkstra's took " +  (Time.now - start).to_s
  puts "Dijkstra's result from #{initial_node} to"
  puts dijkstra.shortest_path.to_s
end