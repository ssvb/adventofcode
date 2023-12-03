import std;
void main() {
  char[][] grid;
  foreach (s ; stdin.byLine)
    grid ~= s.strip.dup;
  auto w = grid[0].length;
  auto h = grid.length;

  auto adjacentpart = new bool[][](h, w);
  auto adjacentgears = new int[][][](h, w, 0);

  int gearid = 1;
  foreach (x ; 0 .. w) {
    foreach (y ; 0 .. h) {
      if (grid[y][x] != '.' && (grid[y][x] < '0' || grid[y][x] > '9')) {
        foreach (xx ; x - 1 .. x + 2) {
          foreach (yy ; y - 1 .. y + 2) {
            if (xx < 0 || xx >= w || yy < 0 || yy >= h)
              continue;
            adjacentpart[yy][xx] = true;
            if (grid[y][x] == '*')
              adjacentgears[yy][xx] ~= gearid;
          }
        }
        gearid++;
      }
    }
  }

  long part1 = 0;
  long part2 = 0;
  auto tmp = new long[][](gearid, 0);
  foreach (x ; 0 .. w) {
    foreach (y ; 0 .. h) {
      if (grid[y][x] >= '0' && grid[y][x] <= '9') {
        long num = grid[y][x] - '0';
        grid[y][x] = '.';
        int[] gearids = adjacentgears[y][x];
        bool flag = adjacentpart[y][x];
        size_t xx = x + 1;
        while (xx < w && grid[y][xx] >= '0' && grid[y][xx] <= '9') {
          num = num * 10 + grid[y][xx] - '0';
          grid[y][xx] = '.';
          if (adjacentpart[y][xx])
            flag = true;
          if (adjacentgears[y][xx].length != 0)
            gearids ~= adjacentgears[y][xx];
          xx++;
        }
        gearids = gearids.sort.array.uniq.array;
        foreach (idx ; gearids)
          tmp[idx - 1] ~= num;
        if (flag)
          part1 += num;
      }
    }
  }
  foreach (x ; tmp)
    if (x.length == 2)
      part2 += x[0] * x[1];

  writefln!"Part1: %d"(part1);
  writefln!"Part2: %d"(part2);
}
