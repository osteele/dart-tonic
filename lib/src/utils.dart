part of tonic;

/// Call `fn` first with `list[0]` and 0, then with `list[1] `and 1, etc.
void eachWithIndex<T>(List<T> list, void Function(T, int) fn) {
  int i = 0;
  for (final x in list) {
    fn(x, i);
    i += 1;
  }
}

/// Returns a copy of `items, stably sorted by sortKey.
///
/// The implementation uses `collection.insertionSort`, which is optimized for
/// short lists.
List sortedBy<T>(
  Iterable<T> items,
  int Function(T) sortKey, {
  bool reverse = false,
}) {
  final list = new List.from(items);
  final comparator = reverse
      ? (a, b) => sortKey(a) - sortKey(b)
      : (a, b) => sortKey(b) - sortKey(a);
  insertionSort(list, compare: comparator);
  return list;
}
