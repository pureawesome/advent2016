require 'digest'

input = 'ngcjuoqr'
input = 'abc'
@sets = {}

def get_hexdigest(input)
  return @sets[input] if @sets[input]
  md5 = Digest::MD5.new
  md5.update input
  @sets[input] = md5.hexdigest
end

def key?(hex, count, raw_input)
  status = nil
  hex.match(/(.)\1\1/) do |match|
    character = match[1]
    status = (count + 1..count + 1000).to_a.map do |iter|
      get_hexdigest(raw_input + iter.to_s) =~ /(#{character})\1\1\1\1/
    end
    status.any?
  end
  status.any?
end

def get_stretch_hex(hex)
  2016.times { hex = get_hexdigest(hex.downcase) }
  hex
end

def run(raw_input)
  keys = []
  count = 0

  until keys.size == 64 || count > 22555
    input = raw_input + count.to_s
    hex = get_hexdigest(input)
    # part 2
    hex = get_stretch_hex(hex)
    #
    if hex =~ /(\w)\1\1/
      keys << count if key?(hex, count, raw_input)
    end
    count += 1
    p count if count % 1000 == 0
  end
  keys[-1]
end

start_time = Time.now
p run(input)
end_time = Time.now
puts "Time elapsed #{(end_time - start_time)} seconds"
