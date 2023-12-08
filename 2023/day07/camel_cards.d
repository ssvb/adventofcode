import std;

struct Hand { int[] cards; long bid; }

auto eval_hand_type(int[] cards) {
  auto freq = new int[](max(cards.maxElement + 1, 5));
  int jokers = 0;
  cards.each!(card => (card < 0 ? jokers : freq[card]) += 1);
  freq.sort!"a>b";
  freq[0] += jokers;
  return freq[0 .. 5];
}

long solve(string[] input_lines, int[dchar] card_strength) {
  auto hands = input_lines.map!(s => s.split)
    .map!(x => Hand(x[0].map!(card => card_strength[card]).array,
                    x[1].to!long)).array;

  bool hands_comparator(ref Hand hand1, ref Hand hand2) {
    auto hand1_type = eval_hand_type(hand1.cards);
    auto hand2_type = eval_hand_type(hand2.cards);
    if (hand1_type == hand2_type)
      return hand1.cards < hand2.cards;
    return hand1_type < hand2_type;
  }
  hands.sort!hands_comparator;

  long answer = 0;
  foreach (rank, hand ; hands)
    answer += (rank + 1) * hand.bid;
  return answer;
}

void main() {
  auto input_lines = stdin.byLineCopy.array;

  int[dchar] card_strength;
  foreach (idx, card_label ; "AKQJT98765432".retro.array)
    card_strength[card_label] = idx.to!int;

  input_lines.solve(card_strength).writefln!"Part1: %d";

  card_strength['J'] = -1; // Joker has a special strength
  input_lines.solve(card_strength).writefln!"Part2: %d";
}
