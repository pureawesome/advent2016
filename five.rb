require 'digest'

input = 'ffykfhsq'
# input = 'abc'

@hashes = []
i = 0
until @hashes.size == 8
  hash = Digest::MD5.hexdigest(input + i.to_s)
  @hashes.push(hash) if hash[0...5] == '00000'
  i += 1
end

p @hashes.map { |hash| hash[5] }.join
# c6697b55

@pass = Array.new(8)
i = 0
until @pass.compact.size == 8
  hash = Digest::MD5.hexdigest(input + i.to_s)
  @pass[hash[5].to_i] = hash[6] if hash[0...5] == '00000' &&
                                   hash[5].to_i < 8 &&
                                   @pass[hash[5].to_i].nil? &&
                                   hash[5] =~ /\d/
  i += 1
end
p @pass.join
# 8c35d1ab
