require 'digest'

input = 'ngcjuoqr'
test_input = 'abc'
@sets = Hash.new(Float::INFINITY)
@stretches = Hash.new(Float::INFINITY)
@md5 = Digest::MD5.new

def get_hexdigest(input)
  @sets[input] = @md5.hexdigest(input) if @sets[input] == Float::INFINITY
  @sets[input]
end

def key?(character, count, raw_input)
  status = (0...1000).to_a.map.with_index do |iter|
    check = count - 1000 + iter
    next if check < 0
    input = raw_input + check.to_s
    first = get_hexdigest(input).scan(/(.)\1\1/)
    next if first.empty?
    check if character == first[0][0]

    # Part 2
    # return input if get_stretch_hex(input, get_hexdigest(input)) =~ /(#{character})\1\1/
    #
  end
  # p status
  status.compact
end

def get_stretch_hex(input, hash)
  @stretches[input] if @stretches[input] != Float::INFINITY
  2016.times { hash = get_hexdigest(hash.downcase) }
  @stretches[input] = hash
  hash
end

def run(raw_input)
  keys = []
  count = 0

  until keys.size > 64
    input = raw_input + count.to_s
    hex = get_hexdigest(input)
    # part 2
    # hex = get_stretch_hex(input.downcase, hex.downcase)
    #

    if index = hex =~ /(.)\1{4}/
      key = key?(hex[index], count, raw_input)
      keys += key if key
      keys.uniq!
    end
    count += 1
  end
  keys.sort!
end

start_time = Time.now
p run(input)[63]
# p run(test_input)[63] == 22728
end_time = Time.now
puts "Time elapsed #{(end_time - start_time)} seconds"
