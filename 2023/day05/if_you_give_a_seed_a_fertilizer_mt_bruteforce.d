import std;

struct T { long to, from, size; }

long solve_part1(long seed, T[][] transforms) {
  foreach (transform ; transforms) {
    foreach (mapping ; transform) {
      if (seed >= mapping.from && seed < mapping.from + mapping.size) {
        seed += mapping.to - mapping.from;
        break;
      }
    }
  }
  return seed;
}

long solve_part2(long seed, long size, T[][] transforms) {
  // Multithreaded bruteforce
  return taskPool.reduce!"min(a, b)"(long.max,
    iota(seed, seed + size).map!(s => solve_part1(s, transforms)));
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

  seeds.map!(seed => solve_part1(seed, transforms))
       .minElement.writefln!"Part1: %d";

  seeds.chunks(2).map!(chunk => solve_part2(chunk[0], chunk[1], transforms))
       .minElement.writefln!"Part2: %d";
}
