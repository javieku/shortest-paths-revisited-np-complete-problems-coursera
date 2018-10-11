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

    start = Time.now

    minheap = Heap.new { |x, y|
       x_aux = x.split(".")[1]   
       y_aux = y.split(".")[1]
      (x_aux.to_f <=> y_aux.to_f) == -1 }
    precussors = {}

    graph.nodes.each do |node|
      @shortest_path[node.first] = 0.0
      edge = graph.edge(initial_node,node.first);
      if (edge) 
        heap_value = ExtendedNode.new(node.first,edge.weight)
        precussors[node.first] = initial_node.to_s+"#"+edge.weight.to_s
        minheap.push(initial_node.to_s+"#"+edge.weight.to_s, heap_value) if node.first != initial_node && edge != nil
      end
    end

    puts "Dijkstra's initialization done  " +  (Time.now - start).to_s
    
    explored = Set[initial_node]
    while(explored.length != graph.nodes.size)
      puts "Dijkstra's extract-min starting " +  (Time.now - start).to_s

      best = minheap.pop
      puts "Dijkstra's extract-min done " + best.node.to_s + " " +  (Time.now - start).to_s

      if (!best)
        unreachable_nodes = (explored.to_a - graph.nodes.keys) | (graph.nodes.keys - explored.to_a)
        for v in unreachable_nodes
          @shortest_path[v] = FIXNUM_MAX
        end
        break;
      end

      @shortest_path[best.node] = best.weight
      explored.add(best.node)

      puts "Dijkstra's for done " + best.node.to_s + " " +  (Time.now - start).to_s

      graph.successors(best.node).each do |node|

        if(explored.include?(node.first))
          next
        end

        current_precussor = precussors[node.first]

        edge = graph.edge(best.node,node.first);
        heap_value = ExtendedNode.new(node.first, best.weight + edge.weight)
        precussors[node.first] = node.first.to_s+"#"+(best.weight + edge.weight).to_s
        if(current_precussor && current_precussor.split("#")[1].to_f > best.weight + edge.weight)
          minheap.delete( current_precussor)
        end
        minheap.push(node.first.to_s+"#"+(best.weight + edge.weight).to_s, heap_value)
      end

      puts "Dijkstra's update heap done " + best.node.to_s + " "+  (Time.now - start).to_s

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
