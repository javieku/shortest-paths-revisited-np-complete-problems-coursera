require_relative 'common'
require_relative 'graph'

class DijktraAlgorithm
  attr_reader :shortest_path
  def initialize
    @shortest_path = {}
  end

  def execute graph, initial_node
    graph.nodes.each do |node|
      @shortest_path[node.first] = 0.0
    end
    
    explored = [initial_node]
    while(explored.length != graph.nodes.size)
      # dijkstra greedy criterion
      edge = select_minimun_edge(graph, explored)

      if (!edge)
        unreachable_nodes = (explored - graph.nodes.keys) | (graph.nodes.keys - explored)
        for v in unreachable_nodes
          @shortest_path[v] = FIXNUM_MAX
        end
        break;
      end

      @shortest_path[edge.dst] = @shortest_path[edge.src] +  edge.weight
      explored.push(edge.dst)
    end
  end

  def to_s 
    result = ""
    @shortest_path.each do |item|
      result += "--[#{item[1].to_s}]--> #{item[0].to_s}  # "
    end
    result
  end

  def result_for nodes 
    result = ""
    nodes.each do |node|
      result += "--[#{@shortest_path[node].to_s}]--> #{node.to_s}  # "
    end
    result
  end

private
  def select_minimun_edge graph, explored
    candidates = []
    explored.each do |node|
      candidate = graph.nodes[node].select_candidates(explored)
      candidates.push(candidate) if (candidate != nil)    
    end

    candidates.flatten!
    
    return candidates.min_by do |edge|
      @shortest_path[edge.src] + edge.weight
    end
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
