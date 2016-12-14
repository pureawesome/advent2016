def nums_regex(str)
  str.match(/(\d+)(?:x)(\d+)/)
end

def pair_splits(str)
  splits = []
  while str =~ /(\d+)(?:x)(\d+)/
    nums = nums_regex(str)
    length = nums[1].to_i
    start = str.index(/\(/)
    slice = str.slice!(start, nums[0].size + length + 2)
    splits.push(slice)
  end
  splits.push(str)
  splits
end

def decomp(str)
  nums = nums_regex(str)
  return str.size unless nums
  start = 3 + nums[0].size
  copy = str.slice(start, nums[1].to_i)
  copy * nums[2].to_i
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

data = File.read('nine.txt').chomp
p part1_size(data)
