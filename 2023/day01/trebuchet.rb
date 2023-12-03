# Works with both Ruby and Crystal
words = "one, two, three, four, five, six, seven, eight, nine".split(/[^\w]+/)
part1, part2 = 0, 0
while s = gets
  part1 += $1.to_i * 10 if s =~ /([0-9])/
  part1 += $1.to_i if s.reverse =~ /([0-9])/
  words.each_with_index {|word, idx| s = s.gsub(/#{word}/, "\\0#{idx + 1}\\0") }
  part2 += $1.to_i * 10 if s =~ /([0-9])/
  part2 += $1.to_i if s.reverse =~ /([0-9])/
end
puts "Part1: #{part1}"
puts "Part2: #{part2}"
