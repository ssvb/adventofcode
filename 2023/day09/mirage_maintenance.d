import std;

ElementType!T interpolate(T)(T a) {
  ElementType!T[] b;
  bool allzero = true;
  foreach (i ; 1 .. a.length) {
    b ~= a[i] - a[i - 1];
    allzero &= (b.back == 0);
  }
  return allzero ? a.back : a.back + interpolate(b);
}

void main() {
  auto input = stdin.byLine.map!(s => s.splitter.map!(to!long).array).array;
  input.map!(a => a.interpolate).sum.writefln!"Part1: %d";
  input.map!(a => a.retro.interpolate).sum.writefln!"Part2: %d";
}
