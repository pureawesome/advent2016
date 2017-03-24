input = '.^..^....^....^^.^^.^.^^.^.....^.^..^...^^^^^^.^^^^.^.^^^^^^^.^^^^^..^.^^^.^^..^.^^.^....^.^...^^.^.'
TRAP = '^'.freeze
SAFE = '.'.freeze

def run(input, total_rows)
  row = input.split('')
  rows = []
  rows << row

  (total_rows - 1).times.with_index do |r_index|
    next_row = rows[r_index].map.with_index do |_item, index|
      parent_indexes = ((index - 1)..(index + 1)).to_a.map { |parent| parent < 0 || parent > rows[0].size - 1 ? nil : parent }
      if (!parent_indexes[0].nil? && rows[r_index][parent_indexes[0]] == '^') &&
         (parent_indexes[2].nil? || rows[r_index][parent_indexes[2]] != '^')
        TRAP
      elsif (!parent_indexes[2].nil? && rows[r_index][parent_indexes[2]] == '^') &&
            (parent_indexes[0].nil? || rows[r_index][parent_indexes[0]] != '^')
        TRAP
      else
        SAFE
      end
    end
    rows << next_row
  end

  p rows.flatten.select {|i| i == '.'}.size
end

# run(input, 40)
run(input, 400000)
