import std;

long interpolate(bool reverse)(long[] a) {
  long[] b;
  bool allzero = true;
  foreach (i ; 1 .. a.length) {
    b ~= a[i] - a[i - 1];
    if (b.back != 0)
      allzero = false;
  }
  if (!allzero) {
    return reverse ? a.front - interpolate!reverse(b) :
                     a.back + interpolate!reverse(b);
  }
  return reverse ? a.front : a.back;
}

void main() {
  auto input = stdin.byLine.map!(s => s.splitter.map!(to!long).array).array;
  input.map!(interpolate!false).sum.writefln!"Part1: %d";
  input.map!(interpolate!true).sum.writefln!"Part2: %d";
}
