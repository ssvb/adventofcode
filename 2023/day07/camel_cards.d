import std;

struct Deck { int[] cards; long bid; }

auto eval_deck_type(int[] cards) {
  auto freq = new int[](max(cards.maxElement + 1, 5));
  int jokers = 0;
  foreach (card ; cards) {
    if (card < 0)
      jokers++;
    else
      freq[card]++;
  }
  freq.sort!"a>b";
  if (freq[0] + jokers == 5)
    return 7; // five of kind
  if (freq[0] + jokers == 4)
    return 6; // four of kind
  if (freq[0] + jokers == 3 && freq[1] == 2)
    return 5; // full house
  if (freq[0] + jokers == 3)
    return 4; // three of kind
  if (freq[0] + jokers == 2 && freq[1] == 2)
    return 3; // two pair
  if (freq[0] + jokers == 2)
    return 2; // one pair
  if (freq[4] == 1)
    return 1; // high card
  return 0;
}

long solve(string[] input_lines, int[dchar] card_strength)
{
  auto decks = input_lines.map!(s => s.split)
    .map!(x => Deck(x[0].map!(card => card_strength[card]).array,
                    x[1].to!long)).array;

  bool decks_comparator(ref Deck deck1, ref Deck deck2) {
    int deck1_type = eval_deck_type(deck1.cards);
    int deck2_type = eval_deck_type(deck2.cards);
    if (deck1_type == deck2_type)
      return deck1.cards < deck2.cards;
    return deck1_type < deck2_type;
  }
  decks.sort!decks_comparator;

  long answer = 0;
  foreach (i, deck ; decks)
    answer += (i + 1) * deck.bid;
  return answer;
}

void main() {
  auto input_lines = stdin.byLineCopy.array;

  int[dchar] card_strength;
  foreach (i, card ; "A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, 2".split(", ").retro.array)
    card_strength[card[0]] = i.to!int;

  input_lines.solve(card_strength).writefln!"Part1: %d";

  card_strength['J'] = -1; // Joker has a special strength
  input_lines.solve(card_strength).writefln!"Part2: %d";
}
