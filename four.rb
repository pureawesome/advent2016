rooms = %w(
  aaaaa-bbb-z-y-x-123[abxyz]
  a-b-c-d-e-f-g-h-987[abcde]
  not-a-real-room-404[oarel]
  totally-real-room-200[decoy]
)

rooms = File.readlines('four.txt').map(&:strip)

def real?(room_str)
  checksum = /\[([a-z]+)\]/.match(room_str)[1]
  name = /(\D+)\d/.match(room_str)[1]
  checksum == letters_by_count(name)
end

def letters_by_count(str)
  str .delete('-')
      .split('')
      .each_with_object(Hash.new(0)) { |l, counts| counts[l] += 1 }
      .sort { |a, b| a[1] == b[1] ? b[0] <=> a[0] : a[1] <=> b[1] }
      .each.flat_map { |arr| arr[0] }
      .reverse.slice(0, 5).join
end

def sector(room_str)
  /\d+/.match(room_str)[0].to_i
end

p rooms.map { |room| sector(room) if real?(room) }.compact.inject(:+)
# 137896

#
@storage_room

# part 2
alpha = ('a'..'z').to_a
rooms_2 = rooms.dup
rooms_2.map do |room|
  offset = sector(room)
  name = /(\D+)\d/.match(room)[1].delete('-').split('')
  new_name = name.map { |letter| alpha[(alpha.index(letter) + offset) % 26] }.join
  @storage_room = room if /northpole/ =~ new_name
  break if @storage_room
end

p @storage_room
