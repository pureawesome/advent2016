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
  @position[@direction_key[@direction]] += (dist.to_i * up_down)
end

p @position.map{ |n| n.abs }.inject(:+)
# 273
