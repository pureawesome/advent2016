test_data = %w(ULL
RRDDD
LURDL
UUUUD
)

input = File.readlines('two.txt').map(&:strip)

@instr = input.dup
@nums = (1..9).to_a
@position = [1, 1]
@dirs = {
  'U' => [0, -1],
  'L' => [-1, 0],
  'R' => [1, 0],
  'D' => [0, 1]
}

def coord_to_num(coord)
  index = (coord[1] * 3) + coord[0]
  @nums[index]
end

def off_grid(coords)
  off = FALSE
  coords.each do |coord|
    if coord < 0 || coord > 2
      off = TRUE
      break
    end
  end
  off
end

def run
  @instr.map! do |line|
    line.split('').each do |code|
      move = @dirs[code]
      new_coord = [move[0] + @position[0], move[1] + @position[1]]
      next if off_grid(new_coord)
      @position = new_coord
    end
    coord_to_num(@position)
  end
  @instr.join.to_s
end

p run
