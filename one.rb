input = File.read('one.txt').split(',').map(&:strip)

@position = [0, 0]
@direction_key = {
  'n' => 1,
  's' => 1,
  'e' => 0,
  'w' => 0
}

@directions = ['n', 'e', 's', 'w']
@direction = 'n'

# part 2
@stops = []
@overlap = []

def turn(dir)
  heading_index = @directions.rindex(@direction)
  change = dir == 'L' ? heading_index - 1 : heading_index + 1
  change = 0 if change > (@directions.length - 1)
  change = (@directions.length - 1) if change < 0
  @directions[change]
end

input.each do |walk|
  dir = walk[0...1]
  dist = walk[1..-1]
  @direction = turn(dir)
  up_down = (@direction == 's' || @direction == 'w') ? -1 : 1

  # part 1 start
  # @position[@direction_key[@direction]] += (dist.to_i * up_down)
  # part 1 end

  # part 2 start
  dist.to_i.times do
    @position[@direction_key[@direction]] += (1 * up_down)
    if @stops.include? @position.dup
      @overlap = @position.dup
      break
    end
    @stops.push @position.dup
  end
  break if @overlap.any?
  # part 2 end
end

p @position.map(&:abs).inject(:+)
# 273
# #115
