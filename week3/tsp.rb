require 'singleton'

FIXNUM_MAX = (2**(0.size * 8 - 2) - 1)
FIXNUM_MIN = -(2**(0.size * 8 - 2))

class TravellingSalesmanHeuristic
  attr_reader :cost
  attr_reader :path

  def execute(input)
    cities = input.clone
    current_city = cities.shift
    @cost = 0
    @path = []
    path.push(current_city)
    start = Time.now
    while(!cities.empty?) do
      next_city = select_next(cities, current_city)
      @cost += euclidean_distance(next_city, current_city)
      cities.delete(next_city)
      current_city = next_city
      @path.push(next_city)

      if (cities.size % 100 == 0)
        puts 'Remaining cities ' + cities.size.to_s + " " + (Time.now - start).to_s
      end

    end
    @path.push(input.first)
    @cost += euclidean_distance(current_city, input.first)
  end

  def select_next(cities, current_city)

    closest_city = nil
    closest_distance = FIXNUM_MAX
    cities.each{ |city|
      distance = euclidean_distance(current_city, city)
      if distance < closest_distance
        closest_city = city
        closest_distance = distance
      elsif distance == closest_distance
        closest_city = city if closest_city.id > city.id
      end
    }

    closest_city
  end

  def euclidean_distance(point1, point2)
    sum_of_squares = 0
    sum_of_squares += (point2.x - point1.x)**2
    sum_of_squares += (point2.y - point1.y)**2
    Math.sqrt(sum_of_squares)
  end
end

class City
  attr_reader :x
  attr_reader :y
  attr_reader :id
  def initialize(x, y, id)
    @x = x
    @y = y
    @id = id
  end

  def to_s
    '(id: ' + @id.to_s + ' x: ' + @x.to_s + ' y: ' + @y.to_s + ')'
  end
end

class InputLoader
  include Singleton
  def read_cities(filename)
    cities = []
    File.open(filename, 'r') do |f|
      f.each_with_index do |line, index|
        if index == 0
          next
        else
          position = line.split(/\s/).reject(&:empty?)
          x = position[1].to_f
          y = position[2].to_f
          cities.push(City.new(x, y, index))
          end
      end
    end
    cities
  end
end

def main
  start = Time.now
  city_distances = InputLoader.instance.read_cities 'nn.txt' #"first_1000_sol_48581.txt" 
  puts 'Cities loaded in memory ' + (Time.now - start).to_s
  start = Time.now
  heuristic = TravellingSalesmanHeuristic.new
  heuristic.execute(city_distances)
  puts 'Travelling Salesman Heuristic executed ' + (Time.now - start).to_s
  puts 'Minimun cost of a cycle around all the cities is ' + heuristic.cost.to_s
  #puts 'Path ' + heuristic.path.to_s
end

main
