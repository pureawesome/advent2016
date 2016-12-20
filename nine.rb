def nums_regex(str)
  str.match(/(\d+)(?:x)(\d+)/)
end

def pair_splits(str)
  splits = []
  while str =~ /(\d+)(?:x)(\d+)/
    nums = nums_regex(str)
    start = str.index(/\(/)
    slice = str.slice!(start, nums[0].size + nums[1].to_i + 2)
    splits.push(slice)
  end
  splits.push(str)
  splits
end

def decomp_to_num(str)
  nums = nums_regex(str)
  return str.size unless nums
  nums[1].to_i * nums[2].to_i
end

def part1_size(data)
  splits = pair_splits(data)
  decomps = splits.map { |str| decomp_to_num(str) }
  decomps.inject(:+)
end

def part2_size(data)
  total = 0
  computed = ''
  while data =~ /\(/
    splits = pair_splits(data)
    splits.map! do |split|
      if split =~ /\(/
        matches = split.scan(/\(/)
        if matches.size == 1
          total += decomp_to_num(split)
          computed
        else
          nums = nums_regex(split)
          new_splits = pair_splits(split[nums[0].size + 2..-1])
          new_splits.map do |str|
            str.sub!(/x(\d+)\)/) do |match|
              new_number = (match[1..-2].to_i * nums[2].to_i).to_s
              'x' + new_number + ')'
            end
          end
        end
      else
        total += split.size
        computed
      end
    end
    data = splits.join
  end
  total
end

data = File.read('nine.txt').chomp
# p part1_size(data)
p part2_size(data)
