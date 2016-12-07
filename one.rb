input = File.read('one.txt')
            .split(',')
            .map(&:strip)
            .map { |order| [order[0...1], order[1..-1].to_i] }

@position = [0, 0]

# x/y index, pos/neg
@dir_info = {
  'n' => [1, 1], # n
  'e' => [0, 1], # e
  's' => [1, -1], # s
  'w' => [0, -1], # w
}

@directions = %w(n e s w)
@direction = 'n'

# part 2
@stops = []
@overlap = false

def turn(dir)
  current_index = @directions.rindex(@direction)
  new_index = dir == 'L' ? current_index - 1 : current_index + 1
  @directions[new_index % @directions.size]
end


input.each do |walk|
  @direction = turn(walk[0])

  # part 1 start
  # @position[@dir_info[@direction][0]] += (walk[1] * @dir_info[@direction][1])
  # part 1 end

  # part 2 start
  walk[1].times do
    @position[@dir_info[@direction][0]] += (1 * @dir_info[@direction][1])
    @overlap = true if @stops.include? @position
    break if @overlap
    @stops.push @position.dup
  end
  break if @overlap
  # part 2 end
end

p @position.map(&:abs).inject(:+)
# 273
# #115
