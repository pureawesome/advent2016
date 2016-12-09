# test_ips = %w(
#   abba[mnop]qrst
#   abcd[bddb]xyyx
#   aaaa[qwer]tyui
#   ioxxoj[asdfgh]zxcvbn
# )
#
# test_ips = %w(
#   aba[bab]xyz
#   xyx[xyx]xyx
#   aaa[kek]eke
#   zazbz[bzb]cdb
# )
#

test_ips = File.readlines('seven.txt')

def supports_abba?(str)
  hypernets = str.scan(/\[([\D+]+?)\]/).flatten.map { |match| contains_abba?(match) }
  return false if hypernets.any?
  ips = str.scan(/(?:^|\])([\D+]+?)(?:\[|$)/).flatten.map { |match| contains_abba?(match) }
  return true if ips.any?
  false
end

def supports_aba?(str)
  hypernets = str.scan(/\[([\D+]+?)\]/).flatten.flat_map { |match| contains_aba?(match) }
  ips = str.scan(/(?:^|\])([\D+]+?)(?:\[|$)/).flatten.flat_map { |match| contains_aba?(match) }
  hypernets_bab = hypernets.flat_map { |net| to_bab(net) }
  (hypernets_bab & ips).any?
end

def contains_abba?(str)
  status = false
  (str.size - 3).times do
    status = abba?(str)
    break if status
    str = str.split('').rotate(1).join
  end
  status
end

# part 2
def contains_aba?(str)
  abas = []
  (str.size - 2).times do
    abas.push(str[0..2]) if aba?(str)
    str = str.split('').rotate(1).join
  end
  abas
end

def abba?(str)
  str[0...2] == str[2...4].reverse && str[0] != str[1]
end

# part 2
def aba?(str)
  str[0] == str[2] && str[0] != str[1]
end

def to_bab(str)
  [str[1] + str[0] + str[1]]
end

test_ip_results = test_ips.map { |ip| supports_abba?(ip) }
test_ip_results_2 = test_ips.map { |ip| supports_aba?(ip) }

p test_ip_results.count(true)
p test_ip_results_2.count(true)
