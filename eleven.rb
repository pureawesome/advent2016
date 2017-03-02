# all states that have existed
@dists = Hash.new(Float::INFINITY)

def check_if_already?(state)
  check = state[1..2]
  return true if @dists[check] != Float::INFINITY
  @dists[check] = state[0]
  false
end

def get_item_type(item, level)
  return :p if level.include?(@opposites[item])
  return :g if item[-1] == 'G'
  return :m if item[-1] == 'M'
  puts 'problem'
  raise 'error'
end

def check_level_status?(level)
  is_okay = level.map { |item| get_item_type(item, level) }
  (is_okay.include?(:m) && (is_okay.include?(:g) || is_okay.include?(:p))) ? false : true
end

def check_if_completed?(state)
  state[0].empty? && state[1].empty? && state[2].empty?
end

def build_opposites_hash(levels)
  @opposites = {}
  levels.flatten.each { |item| @opposites[item] = item[-1] == 'G' ? (item[0..1] + 'M').to_sym : (item[0..1] + 'G').to_sym }
end

def get_sets(floor)
  sets = floor.dup
  sets = sets.map { |item| [item] } + sets.combination(2).to_a
  sets.select { |item| check_level_status?(floor - item) && check_level_status?(item) }
end

def run_state(start_state)
  states = [start_state]
  check_if_already?(start_state)
  done = false
  until done
    return if states.empty?
    state = states.shift
    el = state[1][0]
    sets = get_sets(state[2][el].dup)
    next if sets.empty?
    dirs = []
    dirs.push(-1) if el >= 1
    dirs.push(1) if el < 3
    combos = dirs.flat_map { |dir| sets.map { |set| [dir, set] } }

    combos.each do |combo|
      dir = combo[0]
      item = combo[1]
      next if dir == -1 && state[0...el].map(&:empty?).all?
      new_state = state.map(&:dup)
      new_state[2][el + dir] = (new_state[2][el + dir] + item).sort
      next unless check_level_status?(new_state[2][el + dir])
      new_state[2][el] = (new_state[2][el] - item).sort
      done = new_state[0][0] + 1 if check_if_completed?(new_state[2])
      new_state[1][0] += dir
      next if check_if_already?(new_state)
      new_state[0][0] += 1
      states.push(new_state)
    end
  end
  done
end

def setup(data)
  state = [[0], [0]]
  levels = []
  data.each do |line|
    level = []
    line.scan(/(\w+)\sgenerator/) { |match| level.push((match[0][0..1].upcase + 'G').to_sym) }
    line.scan(/(\w+)\-\w+\smicrochip/) { |match| level.push((match[0][0..1].upcase + 'M').to_sym) }
    levels.push(level)
  end
  levels.map!(&:sort)
  build_opposites_hash(levels)
  state.push(levels)
end

@beginning_time = Time.now
# data = File.readlines('eleven_test.txt').map(&:strip)
# data = File.readlines('eleven.txt').map(&:strip)
data = File.readlines('eleven2.txt').map(&:strip)
start_state = setup(data)
final = run_state(start_state)
p final
@end_time = Time.now
puts "Time elapsed #{(@end_time - @beginning_time)} seconds"
