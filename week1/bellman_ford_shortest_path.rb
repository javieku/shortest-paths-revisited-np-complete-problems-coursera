require_relative 'common'
require_relative 'graph'

class BellmanFordAlgorithm
  attr_reader :shortest_path
  attr_reader :has_negative_cycle

  def initialize
    @shortest_path = []
    @has_negative_cycle = false
  end

  def execute graph, initial_vertex
    n = graph.size;
    result = Array.new(n);
    for i in (0..n)
        result[i] = Array.new(n);
    end

    for v in (1..n)
        if (v == initial_vertex)
            result[0][v] = 0
        else
            result[0][v] = FIXNUM_MAX
        end   
    end

    for i in (1..n-1)
        for v in (1..n)
            edge = graph.predecessors(v).min_by { |pred| pred.weight }
            if(edge == nil)
                result[i][v] = result[i-1][v] 
            else
                result[i][v] = [result[i-1][v], result[i-1][edge.src] + edge.weight].min 
            end
        end
    end

    for v in (1..n)
        edge = graph.predecessors(v).min_by { |pred| pred.weight }
        if(edge == nil)
            result[n][v] = result[n-1][v] 
        else
            result[n][v] = [result[n-1][v], result[n-1][edge.src] + edge.weight].min 
        end
    end
    
    @has_negative_cycle = result[n] != result[n-1];
    @shortest_path = result[n-1];
  end
end

def main
  start = Time.now
  graph = GraphLoader.instance.read_graph "g_bellman_ford.txt"
  puts "Graph loaded in memory " +  (Time.now - start).to_s
  start = Time.now
  puts "Starting Bellman-Ford's algorithm"
  algorithm = BellmanFordAlgorithm.new
  initial_vertex = 1
  algorithm.execute(graph, initial_vertex) 
  puts "Bellman-Ford's took " +  (Time.now - start).to_s
  puts "Bellman-Ford's result -> " +  algorithm.shortest_path.to_s
  puts "Graph has negative cycles -> " +  algorithm.has_negative_cycle.to_s
end

main