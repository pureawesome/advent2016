
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
  level.delete_at(-1)
  mchips = level.select { |item| item[/M$/] }
  mchips_combos = mchips.combination(2).to_a
  gens = level.select { |item| item[/G$/] }.combination(2).to_a
  sames = mchips.map { |mchip| [mchip, get_opposite(mchip)] if level.include?(get_opposite(mchip)) }.compact
  all_pairs.push(mchips_combos).push(gens).push(sames).flatten(1)
end

def check_level_status?(level)
  is_okay = level.map do |item|
    if item.is_a? Numeric
      :e
    elsif level.include?(get_opposite(item))
      :p
    elsif item[-1] == 'G'
      :g
    elsif item[-1] == 'M'
      :m
    else
      raise 'error'
    end
  end
  status = (is_okay.include?(:m) && (is_okay.include?(:g) || is_okay.include?(:p))) ? false : true
  status
end

def get_opposite(str)
  str[-1] == 'G' ? str[0..1] + 'M' : str[0..1] + 'G'
end

def check_if_completed?(states)
  done = states
    .map { |state| state[0].empty? && state[1].empty? && state[2].empty? }
    .any?

  p states if done
  done
end

def get_elevator(state)
  state.each.with_index do |level, index|
    # p index if level.map { |item| item.is_a? Numeric }.any?
    return index if level.map { |item| item.is_a? Numeric }.any?
  end
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
  return if item.is_a? Numeric
  moves = []
  pair_moves = []
  pairs = check_for_pairs(state[el])

  if el < 3
    moves.push(1)
    pair_moves.push(1) unless pairs.empty?
  end

  # if (el - 1) >= 0
  #   moves.push(-1)
  #   # pair_moves.push(-1) unless pairs.empty?
  # end

  unless state[0...el].map(&:empty?).all?
    moves.push(-1)
    # pair_moves.push(-1) unless pairs.empty?
  end

  count = state[el].map { |x| Integer(x) rescue nil }.compact[0]
  new_count = count + 1

  moves.map! do |dir|
    new_state = move_item(deep_copy(state), item, el, dir)
    new_state[el].delete(count)
    new_state[el + dir].push(new_count)

    new_state
  end

  if pairs && pair_moves.any?
    pairs.each do |pair|
      pair_moves.each do |dir|
        pair_state = move_item(deep_copy(state), pair[0], el, dir)
        pair_state = move_item(pair_state, pair[1], el, dir)
        pair_state[el].delete(count)
        pair_state[el + dir].push(new_count)

        moves.push(pair_state)
      end
    end

  end
  moves
end

def run_state(run_state)
  # p run_state
  elevator = get_elevator(run_state)
  active_floor = run_state[elevator].dup
  # p 'active floor'
  # p active_floor
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
  move = 0
  done = false
  until done
    # p states
    state = states.shift
    # p 'state'
    # p state
    new_states = run_state(state)
    # p 'new states'
    # p new_states
    # new_states_2 = states.flat_map { |stater| run_state(stater) }
    # p new_states_2
    move += 1
    done = true if check_if_completed?(new_states)
    states += new_states unless new_states.empty?
    return if states.empty?
    # p 'states added'
    # p states
  end
  p 'done'
end

def setup(data)
  levels = []
  data.each do |line|
    level = []
    line.scan(/(\w+)\sgenerator/) { |match| level.push(match[0][0..1].upcase + 'G') }
    line.scan(/(\w+)\-\w+\smicrochip/) { |match| level.push(match[0][0..1].upcase + 'M') }
    levels.push(level)
  end
  levels[0].push(0)
  levels
end

@beginning_time = Time.now
data = File.readlines('eleven_test.txt').map(&:strip)
# data = File.readlines('eleven.txt').map(&:strip)
start_state = setup(data)
run_moves(start_state)
@end_time = Time.now
puts "Time elapsed #{(@end_time - @beginning_time)} seconds"
