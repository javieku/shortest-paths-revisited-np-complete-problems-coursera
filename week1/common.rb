require 'singleton'

FIXNUM_MAX = (2**(0.size * 8 -2) -1)
FIXNUM_MIN = -(2**(0.size * 8 -2))

class Path
    attr_reader :src
    attr_reader :dst
    attr_reader :cost
    def initialize(src,dst,cost)
      @src = src
      @dst = dst
      @cost = cost
    end
    def to_s
        "(" + @src.to_s + " -> " + @dst.to_s + " : " + cost.to_s + ")"
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