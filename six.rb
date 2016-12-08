codes = File.readlines('six.txt').map(&:strip)

code_size = codes[0].size

splits = Array.new(code_size) { [] }

codes.map { |code| code.split('') }
     .each do |letter_arr|
       letter_arr.each.with_index do |l, i|
         splits[i].push(l)
       end
     end

ranks = splits.map do |arr|
  arr.each_with_object(Hash.new(0)) { |l, counts| counts[l] += 1 }
     .sort_by { |_k, v| v }.to_a.reverse
end

p ranks.map { |rank| rank[0][0] }.join
# part 2
p ranks.map { |rank| rank[-1][0] }.join
