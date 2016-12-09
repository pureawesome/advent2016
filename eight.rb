
def get_numbers(str)
  str.scan(/\d+/).map(&:to_i)
end

def build_screen
  Array.new(6) { Array.new(50, 0) }
end

def get_instr(str)
  return 'rect' if str =~ /rect/
  return 'col' if str =~ /column/
  return 'row' if str =~ /row/
end

def handle_instr(str, screen)
  instr = get_instr(str)
  nums = get_numbers(str)
  send(instr, nums, screen)
end

def rect(nums, screen)
  nums[1].times.with_index do |y|
    nums[0].times.with_index do |x|
      screen[y][x] = 1
    end
  end
  screen
end

def col(nums, screen)
  column = []
  screen.each { |row| column.push(row[nums[0]]) }
  column.rotate!(nums[1] * -1)
  screen.each.with_index { |row, i| row[nums[0]] = column[i] }
end

def row(nums, screen)
  screen[nums[0]] = screen[nums[0]].rotate(nums[1] * -1)
end

def toggle(light)
  light ? 0 : 1
end

def run(data)
  screen = build_screen
  data.map { |instr| handle_instr(instr, screen) }
end

data = File.readlines('eight.txt').map(&:strip)
# p data
screens = run(data)
p screens[-1].flatten.count(1)
p screens[-1].map { |row| row.map { |letter| letter == 0 ? '.' : 'X' }.join }
