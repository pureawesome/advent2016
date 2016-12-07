triangles = File.readlines('three.txt')
                .map { |set| set.split(' ').map(&:strip).map(&:to_i) }

def triangle?(sides)
  (sides[0] + sides[1]) > sides[2]
end

def check_sides?(triangle)
  status = true
  3.times do
    status = triangle?(triangle)
    break unless status
    triangle.rotate!(1)
  end
  status
end

p triangles.map { |triangle| check_sides?(triangle) }.count(true)

# part 2
triangles_2 = File.readlines('three.txt')
                  .map { |set| set.split(' ').map(&:strip).map(&:to_i) }
                  .each_slice(3).to_a

p triangles_2 .flat_map { |set| set[0].zip(set[1], set[2]) }
              .map! { |triangle| check_sides?(triangle) }
  .count(true)
