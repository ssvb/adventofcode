# Works with both Ruby and Crystal
require "set"
cards = STDIN.each_line.map {|s|
  s.split(":")[1].split("|").map {|x| x.split.map {|x| x.to_i}}}
wins = cards.map {|card| (card[0].to_set & card[1].to_set).size }.to_a
puts "Part1: %d" % wins.map {|cnt| (cnt > 0 ? 2 ** (cnt - 1) : 0) }.sum

cardcopies = [1] * wins.size
wins.each_with_index do |cnt, i|
  (i+1 ... [i+1+cnt, wins.size].min).each {|j| cardcopies[j] += cardcopies[i] }
end
puts "Part2: %d" % cardcopies.sum
