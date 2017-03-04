input = 1362
side = 100
goal = [31, 39]

# test
# input = 10
# side = 10
# goal = [7,4]

def binary_not_even?(num)
  num.split('').map(&:to_i).reduce(:+) % 2
end

def pretty(layout)
  layout.each { |row| p row }
end

def get_raw(x, y)
  x * x + 3 * x + 2 * x * y + y + y * y
end

def build_map(layout, input)
  layout.map.with_index do |y_item, y|
    y_item.map.with_index do |_, x|
      raw = get_raw(x, y) + input
      binary_not_even?(raw.to_s(2)) == 1 ? '#' : '.'
    end
  end
end

def build_stops(layout)
  layout.flat_map.with_index { |yrow, y| yrow.map.with_index { |item, x| [x, y] if item == '#'} }.compact
end

def build_route(layout, goal)
  start = [1, 1]
  moves = [[0, 1], [0, -1], [1, 0], [-1, 0]]
  routes = [[start]]
  stops = build_stops(layout).push(start)
  route = false

  # part 2
  hits = [start]

  while routes
    route = routes.shift
    current = route[-1]
    # part 1
    break if current == goal

    # part 2
    # break if route.size > 50

    moves.each do |move|
      next_coord = [current, move].transpose.map { |x| x.reduce(:+) }
      next if next_coord.any? { |x| x < 0 } || stops.include?(next_coord)
      # part 2
      hits << next_coord
      stops << next_coord
      new_route = route.map(&:dup)
      new_route << next_coord
      routes << new_route
    end
  end
  # part 1
  route.size - 1

  # part 2
  # hits.uniq.size
end

def run(input, side, goal)
  layout = Array.new(side) { Array.new(side) }
  layout = build_map(layout, input)
  build_route(layout, goal)
end

start_time = Time.now
p run(input, side, goal)
end_time = Time.now
puts "Time elapsed #{(end_time - start_time)} seconds"
