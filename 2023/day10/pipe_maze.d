import std;

void show_grid(char[][] grid) {
  foreach (ref row ; grid)
    writeln(row);
  writeln;
}

void bfs(char[][] grid, char ch) {
  auto height = grid.length.to!int;
  if (height == 0)
    return;
  auto width = grid[0].length.to!int;

  struct point { int x, y; }
  DList!point queue;
  foreach (y ; 0 .. height)
    foreach (x ; 0 .. width)
      if (grid[y][x] == ch)
        queue.insertBack(point(x, y));

  while (!queue.empty) {
    auto p = queue.front;
    queue.removeFront;
    if (p.y + 1 < height && grid[p.y + 1][p.x] == '.') {
      grid[p.y + 1][p.x] = ch;
      queue.insertBack(point(p.x, p.y + 1));
    }
    if (p.y - 1 >= 0 && grid[p.y - 1][p.x] == '.') {
      grid[p.y - 1][p.x] = ch;
      queue.insertBack(point(p.x, p.y - 1));
    }
    if (p.x + 1 < width && grid[p.y][p.x + 1] == '.') {
      grid[p.y][p.x + 1] = ch;
      queue.insertBack(point(p.x + 1, p.y));
    }
    if (p.x - 1 >= 0 && grid[p.y][p.x - 1] == '.') {
      grid[p.y][p.x - 1] = ch;
      queue.insertBack(point(p.x - 1, p.y));
    }
  }
}

struct A { long part1, part2; }

A solve(char[][] grid, int x, int y, int dir) {
  //                up       right   down    left
  auto dir2dxdy = [[0, -1], [1, 0], [0, 1], [-1, 0]];
  auto dirchange = [
    ['|' : 0, 'F' : +1, '7' : -1, 'S' : 0],
    ['-' : 0, '7' : +1, 'J' : -1, 'S' : 0],
    ['|' : 0, 'L' : -1, 'J' : +1, 'S' : 0],
    ['-' : 0, 'F' : -1, 'L' : +1, 'S' : 0],
  ];

  auto contour = grid.map!(row => '.'.repeat(row.length).array).array;
  int cycle_length = 0;

  foreach (ref row ; contour)
    row[] = '.';

  void mark_sides(int x, int y, int dir) {
    auto left = &contour[y + dir2dxdy[(4 + dir - 1) % 4][1]]
                        [x + dir2dxdy[(4 + dir - 1) % 4][0]];
    auto right = &contour[y + dir2dxdy[(4 + dir + 1) % 4][1]]
                         [x + dir2dxdy[(4 + dir + 1) % 4][0]];
    if (*left == '.')
      *left = 'l';
    if (*right == '.')
      *right = 'r';
  }

  contour[y][x] = '#';
  do {
    x += dir2dxdy[dir][0];
    y += dir2dxdy[dir][1];
    mark_sides(x, y, dir);
    cycle_length++;
    if (auto dirdiff = (grid[y][x] in dirchange[dir]))
      dir = (4 + dir + *dirdiff) % 4;
    else
      return A(0, 0); // a dead end
    contour[y][x] = '#';
    mark_sides(x, y, dir);
  } while (grid[y][x] != 'S');

  bfs(contour, 'l');
  bfs(contour, 'r');
  version (verbose)
    show_grid(contour);

  assert(cycle_length % 2 == 0);
  return A(cycle_length / 2,
           contour.joiner.count(contour[0][0] == 'l' ? 'r' : 'l'));
}

void main() {
  // add an extra padding of '.'
  auto grid = stdin.byLineCopy.map!(x => ("." ~ x.strip ~ ".").dup).array;
  grid = '.'.repeat(grid[0].length).array ~ grid;
  grid ~= '.'.repeat(grid[0].length).array;

  A[] results;
  foreach (y ; 0 .. grid.length.to!int) {
    foreach (x ; 0 .. grid[y].length.to!int) {
      if (grid[y][x] != 'S')
        continue;
      // try 4 possible directions, filter out duplicates
      results ~= iota(4).map!(dir => solve(grid, x, y, dir))
                        .filter!(x => x.part1 > 0).array
                        .sort!((a, b) => a.part1 > b.part1)
                        .uniq.array;
    }
  }
  // if there are multiple possible answers, then report the longest cycle
  results.sort!((a, b) => a.part1 > b.part1);
  version (verbose)
    writeln(results);
  results[0].part1.writefln!"Part1: %d";
  results[0].part2.writefln!"Part2: %d";
}
