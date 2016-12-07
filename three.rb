triangles = File.readlines('three.txt')
                .map { |set| set.split(' ').map(&:strip).map(&:to_i) }

def triangle?(sides)
  (sides[0] + sides[1]) > sides[2]
end

triangles.map! do |triangle|
  status = true
  triangle.size.times do
    status = triangle?(triangle)
    break unless status
    triangle.rotate!(1)
  end
  status
end

p triangles.count(true)
