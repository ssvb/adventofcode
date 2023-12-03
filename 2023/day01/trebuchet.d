import std;
void main() {
  auto input = stdin.byLineCopy.array;

  try {
    input.map!(s => (s.find!"a >= '0' && a <= '9'".front - '0') * 10 +
                     s.retro.find!"a >= '0' && a <= '9'".front - '0')
         .sum.writefln!"Part1: %d";
  } catch (Error e) {
    writefln!"Part1: malformed input";
  }

  auto words = "one, two, three, four, five, six, seven, eight, nine"
       .split(", ").zip(iota(1, 10))
       .map!(x => tuple(x[0], x[0] ~ x[1].to!string ~ x[0])).array;
  input.map!(s => words.fold!((a, subst) => a.replace(subst[]))(s))
       .map!(s => (s.find!"a >= '0' && a <= '9'".front - '0') * 10 +
                   s.retro.find!"a >= '0' && a <= '9'".front - '0')
       .sum.writefln!"Part2: %d";
}
