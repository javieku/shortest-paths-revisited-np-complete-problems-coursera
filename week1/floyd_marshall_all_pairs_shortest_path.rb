require 'singleton'
require_relative 'graph'
require_relative 'common'

class FloydMarshallAlgorithm
  attr_reader :shortest_paths
  def initialize
    @shortest_paths = []
  end

  def execute graph
    n = graph.size;
    
    start = Time.now

    result = Array.new(n);
    for i in (1..n)
        result[i] = Array.new(n);
        for j in (1..n)
            result[i][j] = Array.new(2);
        end
    end
    
    puts "First initialization done  " +  (Time.now - start).to_s

    for i in (1..n)
        for j in (1..n)
            if (i == j)
                result[i][j][0] = 0
            elsif (graph.contains(i,j))
                result[i][j][0] = graph.edge(i,j).weight
            else
                result[i][j][0] = FIXNUM_MAX
            end   
        end
    end

    puts "Second initialization done  " +  (Time.now - start).to_s

    for k in (1..n)
        for i in (1..n)
            for j in (1..n) 
                src = (k % 2 == 0) ? 1 : 0
                dst = (k % 2 == 0) ? 0 : 1 
                result[i][j][dst] = [result[i][j][src], result[i][k][src] + result[k][j][src]].min    
            end
        end
        puts "Iteration k->" + k.to_s + " " +  (Time.now - start).to_s
    end

    puts "Core algorithm done  " +  (Time.now - start).to_s

    for i in (1..n)
        for j in (1..n)
            @shortest_paths.push(Path.new(i,j,result[i][j][1]))   
        end
    end
    puts "Compute result done  " +  (Time.now - start).to_s
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
  graph = GraphLoader.instance.read_graph "g3.txt"
  puts "Graph loaded in memory " +  (Time.now - start).to_s
  start = Time.now
  puts "Starting Floyd-Marshall's algorithm"
  algorithm = FloydMarshallAlgorithm.new
  algorithm.execute(graph) 
  puts "Floyd-Marshall's took " +  (Time.now - start).to_s
  puts "Floyd-Marshall's result " +  algorithm.shortest_paths.to_s
end

main