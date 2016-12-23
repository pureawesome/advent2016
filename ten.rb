@part1 = ''

def create_bot(line)
  bot = line.match(/(bot \d+)/)[1]
  low = line.match(/low to ((?:bot|output) \d+)/)[1]
  high = line.match(/high to ((?:bot|output) \d+)/)[1]
  {
    bot => {
      'low' => low,
      'high' => high
    }
  }
end

def create_value(line)
  value = line.match(/value (\d+)/)[1]
  bot = line.match(/(bot \d+)/)[1]
  { value => bot }
end

def process(bots, vals)
  dups = vals.values.find_all { |e| vals.values.count(e) > 1 }.uniq
  return vals if dups.empty?
  dups.each do |dup|
    keys = vals.select { |_k, v| v == dup }.flatten.sort
    nums = keys[0..1].map(&:to_i).sort
    @part1 = keys[2] if nums == [17, 61]
    vals[nums[0].to_s] = bots[keys[2]]['low']
    vals[nums[1].to_s] = bots[keys[2]]['high']
  end
  process(bots, vals)
end

def run(data)
  bots = []
  values = []
  data.each do |line|
    bots.push(create_bot(line)) if line =~ /^bot/
    values.push(create_value(line)) if line =~ /^value/
  end

  bots = bots.inject(:merge!)
  values = values.inject(:merge!)
  process(bots, values)

  # part 2.
  p values.key('output 0').to_i * values.key('output 1').to_i * values.key('output 2').to_i
end

data = File.readlines('ten.txt').map(&:strip)

run(data)

p @part1
