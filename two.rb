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
  @nums[(coord[1] * 3) + coord[0]]
end

def off_grid(coords)
  coords.map { |int| int < 0 || int > 2 }.include? true
end

@instr.map! do |line|
  line.split('').each do |code|
    new_coord = [@dirs[code][0] + @position[0], @dirs[code][1] + @position[1]]
    next if off_grid(new_coord)
    @position = new_coord
  end
  coord_to_num(@position)
end

p @instr.join.to_s

# part 2
@instr = input.dup
@nums = (1..9).map(&:to_s).to_a + ('A'..'D').to_a
@line_offset = [2, 1, 0, 1, 2]
@raw_grid = Array.new(5) { Array.new(5) }
@grid = []
[1, 3, 5, 3, 1].each { |size| @grid << @nums.slice!(0, size) }

@grid.each.with_index do |line, line_index|
  line.each.with_index do |code, code_index|
    @raw_grid[line_index][code_index + @line_offset[line_index]] = code
  end
end

@position = [0, 2]

def coord_to_num_2(coord)
  @raw_grid[coord[1]][coord[0]]
end

def off_grid_2(coords)
  coords.map { |int| int < 0 || int > 4 }.include? true
end

@instr.map! do |line|
  line.split('').each do |code|
    new_coord = [@dirs[code][0] + @position[0], @dirs[code][1] + @position[1]]
    next if off_grid_2(new_coord)
    next if coord_to_num_2(new_coord).nil?
    @position = new_coord
  end
  coord_to_num_2(@position)
end

p @instr.join.to_s

# 35749
# 9365C
