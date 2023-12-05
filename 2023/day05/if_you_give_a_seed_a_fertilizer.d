import std;

struct T { long to, from, size; }

long solve(long seed, long size, T[][] transforms) {
  long best = long.max;
  long range_end = seed + size;
  while (size > 0) {
    long orig_seed = seed;
    foreach (transform ; transforms) {
      foreach (mapping ; transform) {
        if (seed >= mapping.from && seed < mapping.from + mapping.size) {
          size = min(size, mapping.from + mapping.size - seed);
          seed += mapping.to - mapping.from;
          break;
        }
        // See the "trickyinput.txt" testcase for the reason why this is
        // necessary in the part 2 (74 -> 14 -> 5). The standard Advent
        // of Code 2023 testcases don't seem to be able to validate this.
        if (seed < mapping.from && seed + size > mapping.from)
          size = mapping.from - seed;
      }
    }
    best = min(best, seed);
    seed = orig_seed + size;
    size = range_end - (orig_seed + size);
  }
  return best;
}

void main() {
  auto seeds = readln.strip.split(':').back.split.map!(to!long);

  T[][] transforms;
  foreach (s ; stdin.byLine) {
    if (!s.find("map:").empty) {
      transforms ~= new T[](0);
      continue;
    }
    if (s.strip.empty)
      continue;
    long to, from, size;
    if (s.formattedRead!"%d %d %d"(to, from, size) == 3)
      transforms.back ~= T(to, from, size);
  }

  seeds.map!(seed => solve(seed, 1, transforms))
       .minElement.writefln!"Part1: %d";

  seeds.chunks(2).map!(chunk => solve(chunk[0], chunk[1], transforms))
       .minElement.writefln!"Part2: %d";
}
