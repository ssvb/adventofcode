# this script can generate large input files for BigInt implementations testing
abort "Usage: ruby generate_random_input [cols] [rows]\n" unless ARGV.size >= 2

srand(0)
cols = ARGV[0].to_i
rows = ARGV[1].to_i
extra = 1 + cols / 5
data = 1.upto(cols + extra).to_a.shuffle
1.upto(rows) do |i|
  offs1 = rand(extra)
  offs2 = rand(extra)
  printf("Card %5d: %s | %s\n", i,
         data[offs1 ... cols + offs1].join(" "),
         data[offs2 ... cols + offs2].join(" "))
end
