import std;
void main() {
  auto cards = stdin.byLine.map!(s =>
    s.split(':')[1].split('|').map!(x => x.splitter.map!(to!int).array));

  auto wins = cards.map!(card =>
    setIntersection(card[0].sort, card[1].sort).count).array;

  wins.map!(cnt => (2L ^^ cnt) / 2).sum.writefln!"Part1: %d";

  auto cardcopies = new long[](wins.length);
  cardcopies[] = 1;
  foreach (i, cnt ; wins)
    cardcopies[i + 1 .. min(i + 1 + cnt, wins.length)] += cardcopies[i];
  cardcopies.sum.writefln!"Part2: %d";
}
