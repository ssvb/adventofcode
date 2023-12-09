/+dub.sdl:+/ import std;

struct CacheEntry { ulong stepinc; uint stepincmod; int dest; }
struct Ghost      { ulong step; uint stepmod; int location; }
struct Node       { bool zspot; int[2] connections; }

long solve(string[] input, int[] directions, int part) {
  const uint mod = directions.length.to!uint;

  // Parse input
  string[2][string] network;
  foreach (s ; input) {
    string label, left, right;
    enforce(s.formattedRead!"%s = (%s, %s)"(label, left, right) == 3);
    network[label] = [left, right];
  }
  // Remap string labels to integer indexes for better performance
  Node[] graph;
  int[string] s2i;
  foreach (idx, label ; network.keys)
    s2i[label] = idx.to!int;
  foreach (label, v ; network) {
    bool zspot = (part == 1 ? label == "ZZZ" : label[2] == 'Z');
    graph ~= Node(zspot, [s2i[v[0]], s2i[v[1]]]);
  }
  // Initialize ghosts
  Ghost[] ghosts;
  foreach (label, idx ; s2i)
    if (part == 1 ? label == "AAA" : label[2] == 'A')
      ghosts ~= Ghost(0, 0, idx);
  if (ghosts.empty)
    return 0;

  auto cache = new CacheEntry[][](graph.length, directions.length);

  auto move(ref Ghost g) {
    // If found in cache, then many steps can be skipped
    auto cache_val = &cache[g.location][g.stepmod];
    if (!cache_val.stepinc) {
      // Slowly walk one step at a time
      auto stepinc = 0;
      auto stepmod = g.stepmod;
      auto location = g.location;
      do {
        int direction = directions[stepmod];
        location = graph[location].connections[direction];
        if (++stepmod >= mod)
          stepmod = 0;
        stepinc++;
      } while (!graph[location].zspot);
      // Save results to cache
      *cache_val = CacheEntry(stepinc, stepinc % mod, location);
    }
    // Update the ghost position using the data from cache
    g.step += cache_val.stepinc;
    if ((g.stepmod += cache_val.stepincmod) >= mod)
      g.stepmod -= mod;
    g.location = cache_val.dest;
    return g;
  }

  // Move every ghost to their first Z-location
  ghosts.each!move;
  auto maxstep = ghosts.map!(g => g.step).maxElement;
  // Keep moving every ghost that is left behind
  bool done = false;
  while (!done) {
    done = true;
    foreach (ref g ; ghosts) {
      if (g.step < maxstep) {
        maxstep = max(maxstep, move(g).step);
        done = false;
      }
    }
  }
  return maxstep;
}

void main() {
  auto directions = readln.strip.map!(c => (c == 'L' ? 0 : 1)).array;
  readln;
  auto input = stdin.byLineCopy.array;
  input.solve(directions, 1).writefln!"Part1: %d";
  input.solve(directions, 2).writefln!"Part2: %d";
}
