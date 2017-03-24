require 'digest'
@codes = Hash.new(Float::INFINITY)
@md5 = Digest::MD5.new
@udlr_coords = [[-1, 0], [1, 0], [0, -1], [0, 1]]
@udlr_letters = %w(U D L R)

def get_hexdigest(input)
  @codes[input] = @md5.hexdigest(input) if @codes[input] == Float::INFINITY
  @codes[input]
end

def get_dirs(str)
  str.split('').map { |dir| dir =~ /b|c|d|e|f/ }
end

def run(input)
  states = [[[0, 0], input]]
  winner = 0

  while !states.empty? # && winner == 0
    state = states.shift
    state.freeze
    code = get_hexdigest(state[1])
    dirs = get_dirs(code[0...4])
    new_states = dirs.map.with_index do |dir, index|
      next if dir.nil?
      new_state = state.dup
      new_state[1] += @udlr_letters[index]
      new_state[0] = [new_state[0], @udlr_coords[index]].transpose.map { |x| x.reduce(:+) }
      next if new_state[0][0] < 0 || new_state[0][1] < 0
      winner = new_state[1] if new_state[0][0] == 3 && new_state[0][1] == 3
      next if new_state[0][0] == 3 && new_state[0][1] == 3
      next if new_state[0][0] > 3 || new_state[0][1] > 3
      new_state
    end
    states += new_states.compact
    # sleep 1
  end

  p winner
end

run('dmypynyp')
