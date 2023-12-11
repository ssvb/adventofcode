import std;

struct P { long x, y; }

void main() {
  auto grid = stdin.byLineCopy.array;
  P[] orig_points;
  foreach (y ; 0 .. grid.length)
    foreach (x ; 0 .. grid[y].length)
      if (grid[y][x] == '#')
        orig_points ~= P(x, y);

  auto expand_points_y = zip(iota(grid.length), grid)
    .filter!(v => v[1].find('#').empty).map!(v => v[0]).array.assumeSorted;
  auto expand_points_x = zip(iota(grid[0].length), grid.transposed)
    .filter!(v => v[1].find('#').empty).map!(v => v[0]).array.assumeSorted;

  long solve(long expand_amount) {
    auto points = orig_points.map!(p =>
      P(p.x + expand_points_x.lowerBound(p.x).length * expand_amount,
        p.y + expand_points_y.lowerBound(p.y).length * expand_amount)).array;
      long sum = 0;
      foreach (i ; 0 .. points.length)
        foreach (j ; i + 1 .. points.length)
          sum += abs(points[i].x - points[j].x) + abs(points[i].y - points[j].y);
      return sum;
  }

  solve(1).writefln!"Part1: %d";
  solve(999999).writefln!"Part2: %d";
}
