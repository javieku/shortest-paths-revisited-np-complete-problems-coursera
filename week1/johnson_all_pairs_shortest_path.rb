require 'singleton'
require_relative 'graph'
require_relative 'common'
require_relative 'bellman_ford_shortest_path'
require_relative 'optimized_dijkstra_shortest_path'

class JohnsonAlgorithm
  attr_reader :shortest_paths
  def initialize
    @shortest_paths = []
  end

  def execute graph
    
    start = Time.now

    root_node = graph.size + 1
    graph.add_node(Node.new(root_node))
    for v in (1..graph.size)
      graph.add_edge(Edge.new(root_node, v, 0))
    end 

    puts "Created fake node connected to all the others  " +  (Time.now - start).to_s
    
    bellmanFord = BellmanFordAlgorithm.new
    bellmanFord.execute(graph, root_node) 

    puts "Run Bellman-Ford's algorithm " +  (Time.now - start).to_s

    graph.remove_node(root_node)
    graph.remove_edges(root_node)

    puts "Removed fake node " +  (Time.now - start).to_s

    # Apply weights to graph 
    graph.reweight_edges(bellmanFord.shortest_path)

    puts "Applied weights to input graph " +  (Time.now - start).to_s

    # Apply Dijktra's algorithm v times
    @shortest_paths = Array.new(graph.size)
    for v in (1..graph.size)
      @shortest_paths[v] = Array.new(graph.size)
      dijkstra = DijktraAlgorithm.new
      dijkstra.execute(graph, v)
      puts "Dijkstra execution for " + v.to_s + " done " +  (Time.now - start).to_s
      for w in (1..graph.size)
        @shortest_paths[v][w] = dijkstra.shortest_path[w] - bellmanFord.shortest_path[v] + bellmanFord.shortest_path[w]
      end   
    end
    
    puts "Run n times Dijktra's algorithm " +  (Time.now - start).to_s 
  end
end

def main
  start = Time.now
  graph = GraphLoader.instance.read_graph "g3.txt"
  puts "Graph loaded in memory " +  (Time.now - start).to_s
  start = Time.now
  puts "Starting Johnson's algorithm"
  algorithm = JohnsonAlgorithm.new
  algorithm.execute(graph) 
  puts "Johnson's took " +  (Time.now - start).to_s
  puts "Johnson's result " +  algorithm.shortest_paths.to_s
end

main