data = %w(
The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
The second floor contains a hydrogen generator.
The third floor contains a lithium generator.
The fourth floor contains nothing relevant.
)

# all states that have existed
@all_states = []

def deep_copy(obj)
  Marshal.load(Marshal.dump(obj))
end

def check_if_okay?(state)
  state.map do |level|
    next if level.size < 2
    check_level_status?(level)
  end.compact.all?
end

def check_if_already?(state)
  @all_states.include? state
end

def check_for_pairs(level)
  level = deep_copy(level)
  all_pairs = []
  level.delete(0)
  mchips = level.select { |item| item[/M$/] }
  mchips_combos = mchips.combination(2).to_a
  gens = level.select { |item| item[/G$/] }
  gens_combos = gens.combination(2).to_a
  sames = mchips.map { |mchip| [mchip, get_opposite(mchip)] if level.include?(get_opposite(mchip)) }.compact
  alls = all_pairs.push(mchips_combos).push(gens_combos).push(sames).flatten(1)
  p alls
  alls
end

# def check_for_mchips(level)
#   level.select { |item| item[/M$/] }
# end

def check_level_status?(level)
  is_okay = level.map do |item|
    next if item == 0
    level.include?(get_opposite(item)) ? :p : item[-1] == 'G' ? :g : :m
  end
  # p level
  # p is_okay
  is_okay.include?(:m) && (is_okay.include?(:g) || is_okay.include?(:p)) ? false : true
end

def get_opposite(str)
  str[-1] == 'G' ? str[0..1] + 'M' : str[0..1] + 'G'
end

def check_if_completed?(states)
  states.map { |state| state[0].empty? && state[1].empty? && state[2].empty? }.any?
end

def get_elevator(state)
  state.each.with_index { |level, index| return index if level.include? 0 }
end

def move_item(state, item, el, dir)
  state[el].delete(item)
  state[el + dir].push(item).sort! { |x, y| y.to_s <=> x.to_s }
  state
end

def pretty_print(orig)
  states = deep_copy(orig)
  states.each do |state|
    state.reverse.each do |level|
      p level
    end
    p '------'
  end

end

def item_moves(item, state, el)
  return if item == 0
  moves = []
  pair_moves = []
  pairs = check_for_pairs(state[el])

  if el < (state.size - 1)
    moves.push(1)
    pair_moves.push(1) if pairs.size > 0
  end

  unless state[0...el].map(&:empty?).all?
    moves.push(-1)
    pair_moves.push(-1) if pairs.size > 0
  end

  moves.map! do |dir|
    new_state = move_item(deep_copy(state), item, el, dir)
    new_state[el].delete(0)
    new_state[el + dir].push(0)

    new_state
  end

  if pairs && pair_moves.any?
    pairs.each do |pair|
      pair_moves.each do |dir|
        pair_state = move_item(deep_copy(state), pair[0], el, dir)
        pair_state = move_item(pair_state, pair[1], el, dir)
        pair_state[el].delete(0)
        pair_state[el + dir].push(0)

        moves.push(pair_state)
      end
    end

  end
  moves
end

def run_state(run_state)
  elevator = get_elevator(run_state)
  active_floor = run_state[elevator].dup
  # p '----run state----'
  # pretty_print([run_state])
  new_states = active_floor.flat_map do |item|
    local_state = deep_copy(run_state)
    item_moves(item, local_state, elevator)
  end.compact
  # p new_states
  new_states = new_states.map do |state|
    next if check_if_already?(state)
    @all_states.push(state)
    next unless check_if_okay?(state)
    state
  end
  # p '------------ moves ------------'
  # pretty_print(new_states.compact)
  new_states.compact
end

def run_moves(start_state)
  states = []
  states.push(start_state)
  moves = 0
  done = false
  until (done || moves > 33)
  # while moves < 12
    states = states.flat_map { |state| run_state(state) }
    moves += 1
    p "-----------------------------------------------#{moves}"
    done = true if check_if_completed?(states)
  end
  p moves
end

def setup(data)
  levels = []
  data.each do |line|
    level = []
    line.scan /(\w+)\sgenerator/ do |match|
      level.push(match[0][0..1].upcase + 'G')
    end
    line.scan /(\w+)\-\w+\smicrochip/ do |match|
      level.push(match[0][0..1].upcase + 'M')
    end
    levels.push(level)
  end
  # elevator is 0
  levels[0].push(0)
  levels
end

@beginning_time = Time.now
data = File.readlines('eleven_test.txt').map(&:strip)
# data = File.readlines('eleven.txt').map(&:strip)
start_state = setup(data)
p start_state
# p start_state

run_moves(start_state)
@end_time = Time.now
puts "Time elapsed #{(@end_time - @beginning_time)} seconds"
# best is Time elapsed 0.026472 seconds
p @all_states.size
# p check_for_pairs(["85M", "88G", "85G", '88M', '23M', 0])
# p check_level_status?(["88M", "85M", "85G", 0])
