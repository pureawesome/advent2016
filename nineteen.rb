data = 3_017_957
# data = 41

def run(input)
  bases = []
  while input > 1
    base = Math.log2(input).floor
    input -= 2**base
    bases.push(base)
  end
  bases.shift
  bases.push(0)
  ans = bases.map { |i| 2**i }.inject(:+)
  ans * 2 + 1
end

p run(data)
