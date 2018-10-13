require 'singleton'

FIXNUM_MAX = (2**(0.size * 8 -2) -1)
FIXNUM_MIN = -(2**(0.size * 8 -2))

class TravellingSalesmanAlgorithm
    attr_reader :minimum_cost

    def execute city_distances
      n = city_distances.size;
      
      start = Time.now

      cities = []
      for m in (1...n)
        cities.push(m)
      end
      s = cities.combination(1).to_a

      initial_array = []
      for i in (0...n)
        initial_array[i] = FIXNUM_MAX
      end

      a = {}
      for k in (0...s.size())
        a[s[k]] = initial_array.dup
        if(s[k] == [1])
          a[s[k]][1] = 1
        else
          a[s[k]][k] = FIXNUM_MAX
        end
      end

      result = Array.new(n);
      for m in (2..n)
        all_s = cities.combination(m).to_a
        for i in (0...all_s.size()) 
            s = all_s[i]
            for j in (0...s.size())
                if (s[j] == 1)
                    next
                end
                minimum = FIXNUM_MAX
                for k in (0...s.size())
                    if (s[k] == s[j])
                        next
                    end
                    aux = s.dup
                    aux.delete(s[j])
                    c = euclidean_distance(city_distances[s[k]],city_distances[s[j]])

                    minimum = [a[aux][s[k]] + c, minimum].min if a.has_key?(aux) 
                end
                a[s] = initial_array.dup unless a.has_key?(s) 
                a[s][j] = minimum
            end
        end 
      end
      @minimum_cost = FIXNUM_MAX
      for j in (2..n)
        c = euclidean_distance(city_distances[1],city_distances[j])
        @minimum_cost = [a[cities][j] + c, @minimum_cost].min
      end
    end

    def euclidean_distance(p1,p2)
        sum_of_squares = 0
        sum_of_squares += (p2.x - p1.x) ** 2
        sum_of_squares += (p2.y - p1.y) ** 2
        Math.sqrt( sum_of_squares )
      end
end

class City
    attr_reader :x
    attr_reader :y
    attr_reader :id
    def initialize(x,y,id)
        @x = x
        @y = y
        @id = id
    end
    def to_s
        "(id: " + @id.to_s + " x: " + @x.to_s + " y: " + @y.to_s + ")"
    end
end

class InputLoader
    include Singleton
    def read_cities filename
        cities = []
        File.open(filename, "r") do |f|
        f.each_with_index do |line,index|
                if (index == 0)
                    next
                else
                    position = line.split(/\s/).reject(&:empty?)
                    x = position[0].to_f
                    y = position[1].to_f
                    cities.push(City.new( x, y, index))
                end
            end
        end
        return cities
    end
end

def main
    start = Time.now
    cities = InputLoader.instance.read_cities "tsp.txt"
    puts "Graph loaded in memory " +  (Time.now - start).to_s
    start = Time.now
    algorithm = TravellingSalesmanAlgorithm.new
    algorithm.execute(cities) 
    puts "Travelling Salesman Algorithm executed " +  (Time.now - start).to_s
    puts "Minimun cost of a cycle around all the cities is " +  algorithm.minimum_cost
end

main