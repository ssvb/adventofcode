import std;

struct T { ulong newsteps; string dest; }
struct G { ulong step; string location; }

long solve(string[] input, int[] directions, int part) {
  string[2][string] network;
  G[] ghosts;

  foreach (s ; input) {
    string node, left, right;
    s.formattedRead!"%s = (%s, %s)"(node, left, right);
    network[node] = [left, right];
    if (part == 1 ? node == "AAA" : node[2] == 'A')
      ghosts ~= G(0, node);
  }

  if (ghosts.empty)
    return 0;

  T[Tuple!(string, ulong)] cache;
  void move(ref G g) {
    ulong step = g.step;
    string location = g.location;
    auto cache_key = tuple(location, step % directions.length);
    if (auto cache_val = (cache_key in cache)) {
      g = G(step + cache_val.newsteps, cache_val.dest);
      return;
    }
    while (true) {
      int direction = directions[step % directions.length];
      location = network[location][direction];
      step++;
      if (part == 1 ? location == "ZZZ" : location[2] == 'Z')
        break;
    }
    cache[cache_key] = T(step - g.step, location);
    g = G(step, location);
  }

  ghosts.each!move;
  while (true) {
    auto maxstep = ghosts.map!"a.step".maxElement;
    auto minstep = ghosts.map!"a.step".minElement;
    if (maxstep == minstep)
      break;
    ghosts.filter!(x => x.step != maxstep).each!move;
  }
  return ghosts.front.step;
}

void main() {
  auto directions = readln.strip.map!(c => (c == 'L' ? 0 : 1)).array;
  readln;
  auto input = stdin.byLineCopy.array;
  input.solve(directions, 1).writefln!"Part1: %d";
  input.solve(directions, 2).writefln!"Part2: %d";
}
