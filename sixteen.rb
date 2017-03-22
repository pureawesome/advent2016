def get_flip(str)
  str.split('').reverse.map { |int| int == '1' ? '0' : '1'}.join
end

def get_checksum(checksum)
  until checksum.size.odd?
    new_checksum = []
    checksum.split('').each_slice(2) { |pair| new_checksum << pair }
    checksum = new_checksum.map { |arr| arr[0] == arr[1] ? '1' : '0' }.join
  end

  checksum
end

def run(input, length)
  a = input
  a = a + '0' + get_flip(a) until a.size > length
  checksum = a.slice(0, length)
  get_checksum(checksum)
end

# p run('11110010111001001', 272)

p run('11110010111001001', 35_651_584)
# p get_flip('11111')
