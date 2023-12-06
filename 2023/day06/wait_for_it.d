import std;

long solve(Tuple!(long, long)[] input) {
  long total = 1;
  foreach (x ; input) {
    auto record_time = x[0];
    auto record_distance = x[1];
    long cnt = 0;
    bool found = false;
    foreach (delay ; size_t.max.iota) {
      auto distance = delay * (record_time - delay);
      if (distance > record_distance) {
        found = true;
        cnt++;
      }
      if (found && distance < record_distance)
        break;
    }
    total *= cnt;
  }
  return total;
}

void main() {
  auto times = readln.splitter(':').back.splitter.map!(to!long);
  auto distances = readln.splitter(':').back.splitter.map!(to!long);

  auto input_p1 = zip(times, distances).array;
  input_p1.solve.writefln!"Part1: %d";

  auto input_p2 = [tuple(times.map!(to!string).join.to!long,
                         distances.map!(to!string).join.to!long)];
  input_p2.solve.writefln!"Part2: %d";
}
