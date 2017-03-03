def blank_register
  {
    a: 0,
    b: 0,
    c: 0,
    d: 0
  }
end

def process(state, instr, index)
  case instr[0]
  when 'cpy'
    state[instr[2].to_sym] = state.key?(instr[1].to_sym) ? state[instr[1].to_sym] : instr[1].to_i
    [state, index += 1]
  when 'inc'
    state[instr[1].to_sym] += 1
    [state, index += 1]
  when 'dec'
    state[instr[1].to_sym] -= 1
    [state, index += 1]
  when 'jnz'
    jnz_index = state.key?(instr[1].to_sym) ? state[instr[1].to_sym] : instr[1].to_i
    index += jnz_index != 0 ? instr[2].to_i : 1
    [state, index]
  else
    raise 'Error'
  end
end

data = File.readlines('twelve.txt')
           .map(&:strip)
           .map { |instr| instr.split(' ') }

def run(data)
  register = blank_register
  index = 0

  # Part 2
  register[:c] = 1

  while index < data.size
    register, index = process(register, data[index], index)
  end

  p register[:a]
end

run(data)
