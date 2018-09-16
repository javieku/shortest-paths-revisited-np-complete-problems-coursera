require 'singleton'
require_relative 'graph'

FIXNUM_MAX = (2**(0.size * 8 -2) -1)
FIXNUM_MIN = -(2**(0.size * 8 -2))

class BellmanFordAlgorithm

  attr_reader :shortest_path

  def initialize
    @shortest_path = []
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

    @shortest_path = result[n-1];
  end
end

class GraphLoader
  include Singleton
  def read_graph filename
    graph = Graph.new
    File.open(filename, "r") do |f|
        f.each_with_index do |line,index|
            if (index == 0)
                next
            else
                edge = line.split(/\s/).reject(&:empty?)
                node_src = edge[0]
                node_dest = edge[1]
                weight = edge[2]
                graph.add_node(Node.new(node_src.to_i))
                graph.add_node(Node.new(node_dest.to_i))
                graph.add_edge(Edge.new(node_src.to_i, node_dest.to_i, weight.to_f))
            end
          end
      end
    return graph
  end
end

def main
  start = Time.now
  graph = GraphLoader.instance.read_graph "g_with_negative_cycle.txt"
  puts "Graph loaded in memory " +  (Time.now - start).to_s
  start = Time.now
  puts "Starting Bellman-Ford's algorithm"
  algorithm = BellmanFordAlgorithm.new
  initial_vertex = 1
  algorithm.execute(graph, initial_vertex) 
  puts "Bellman-Ford's took " +  (Time.now - start).to_s
  puts "Bellman-Ford's result " +  algorithm.shortest_path.to_s
end

main