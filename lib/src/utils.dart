part of tonic;

void eachWithIndex(List list, Function fn) {
  int i = 0;
  for (var x in list) {
    fn(x, i);
    i += 1;
  }
}

List sortedBy(Iterable items, int sortKey(item), {bool reverse: false}) {
  var list = new List.from(items);
  var comparator = reverse
      ? (a, b) => sortKey(a) - sortKey(b)
      : (a, b) => sortKey(b) - sortKey(a);
  insertionSort(list, compare: comparator);
  return list;
}
