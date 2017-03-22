@discs = [
  [5, 4, 1],
  [2, 1, 2]
]

@discs = [
  [7, 0, 1],
  [13, 0, 2],
  [3, 2, 3],
  [5, 2, 4],
  [17, 0, 5],
  [19, 7, 6],
  # part 2
  [11, 0, 7]
]

def run
  time = 0
  done = false

  until done
    done = @discs.map { |disc| (disc[1] + (time + disc[2])) % disc[0] == 0 ? true : false}.all?
    time += 1 unless done
  end
  time
end

p run
