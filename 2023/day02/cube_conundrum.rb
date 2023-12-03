# Works with both Ruby and Crystal
test = [12, 13, 14]
part1 = 0
part2 = STDIN.each_line.sum do |line|
  gameid, trials = line.split(":")
  trials.split(";").map {|trial|
    r, g, b = 0, 0, 0
    r = $1.to_i if trial =~ /(\d+) red/
    g = $1.to_i if trial =~ /(\d+) green/
    b = $1.to_i if trial =~ /(\d+) blue/
    [r, g, b]
  }.reduce([0, 0, 0]) {|a, x| [[a[0], x[0]].max,
                               [a[1], x[1]].max,
                               [a[2], x[2]].max]
  }.tap {|x|
    part1 += $1.to_i if gameid =~ /Game (\d+)/ &&
                        x[0] <= test[0] &&
                        x[1] <= test[1] &&
                        x[2] <= test[2]
  }.reduce(1) {|a, x| a * x }
end
puts "Part1: #{part1}"
puts "Part2: #{part2}"
