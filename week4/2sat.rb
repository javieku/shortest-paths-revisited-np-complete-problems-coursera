require 'singleton'

class PapadimitriousAlgorithm
  attr_reader :is_satisfiable

  def execute(clauses, values)
    @is_satisfiable = false

    Math.log2(values.length).ceil.times do
      values.collect! { 
        [true, false].sample
      }
      n = 2 * values.length * values.length
      n.times do
        clause = holds(clauses, values)
        if !clause
          @is_satisfiable = true
          return
        else
          flipped_variable = [clause.x, clause.y].sample
          values[flipped_variable] = !values[flipped_variable]
        end
      end
    end
  end

  private

  def holds(clauses, values)
    is_satisfiable = true
    clauses.each do |clause|
      if(clause.x_signed < 0 && clause.y_signed < 0)
        is_satisfiable = is_satisfiable && (!values[clause.x] || !values[clause.y])
      elsif (clause.x_signed > 0 && clause.y_signed < 0)
        is_satisfiable = is_satisfiable && (values[clause.x] || !values[clause.y])
      elsif (clause.x_signed < 0 && clause.y_signed > 0)
        is_satisfiable = is_satisfiable && (!values[clause.x] || values[clause.y])
      elsif 
        is_satisfiable = is_satisfiable && (values[clause.x] || values[clause.y])
      end
      return clause if !is_satisfiable
    end
    return nil
  end
end

class Clause
  attr_reader :x
  attr_reader :x_signed
  attr_reader :y
  attr_reader :y_signed
  def initialize(x, y)
    @x = x.to_i.abs
    @x_signed = x.to_i
    @y = y.to_i.abs
    @y_signed = y.to_i
  end

  def to_s
    '(' + @x + '^' + @y + ')'
  end
end

class InputLoader
  include Singleton
  def read_clauses(filename)
    clauses = []
    File.open(filename, 'r') do |file|
      file.each_with_index do |line, index|
        next if index.zero?

        clause = line.split(/\s/).reject(&:empty?)
        x = clause[0]
        y = clause[1]
        clauses.push(Clause.new(x, y))
      end
    end
    clauses
  end

  def read_variables(filename)
    variables = []
    File.open(filename, 'r') do |f|
      f.each_with_index do |line, index|
        break unless index.zero?

        number_of_variables = line.to_f
        variables = Array.new(number_of_variables)
        variables.fill(true)
      end
    end
    variables
  end
end

def main
  start = Time.now
  clauses = InputLoader.instance.read_clauses 'beaunus_11_40_true.txt'
  variables = InputLoader.instance.read_variables 'beaunus_11_40_true.txt'
  puts 'Clauses loaded in memory ' + (Time.now - start).to_s
  start = Time.now
  algorithm = PapadimitriousAlgorithm.new
  algorithm.execute(clauses, variables)
  puts 'Papadimitriou s algorithm executed ' + (Time.now - start).to_s
  puts 'Expresion is satisfiable? ' + algorithm.is_satisfiable.to_s
end

main