part of tonic;

void eachWithIndex(List list, Function fn) {
  int i = 0;
  for (final x in list) {
    fn(x, i);
    i += 1;
  }
}

List sortedBy(Iterable items, int sortKey(item), {bool reverse: false}) {
  final list = new List.from(items);
  final comparator = reverse
      ? (a, b) => sortKey(a) - sortKey(b)
      : (a, b) => sortKey(b) - sortKey(a);
  list.sort(comparator);
  return list;
}
