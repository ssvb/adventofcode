import std;
void main() {
  auto cards = stdin.byLine.map!(s =>
    s.split(':')[1].split('|').map!(x => x.splitter.map!(to!long).array));

  auto wins = cards.map!(card =>
    setIntersection(card[0].sort, card[1].sort).count).array;

  wins.map!(cnt => (BigInt(2) ^^ cnt) / 2).sum.writefln!"Part1: %d";

  auto cardcopies = new BigInt[](wins.length);
  cardcopies[] = BigInt(1);
  foreach (i, cnt ; wins)
    foreach (j ; i + 1 .. min(i + 1 + cnt, wins.length))
      cardcopies[j] += cardcopies[i];
  cardcopies.sum.writefln!"Part2: %d";
}
