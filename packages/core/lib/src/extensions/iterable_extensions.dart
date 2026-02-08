extension IterableX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  Iterable<R> mapIndexed<R>(R Function(int index, T element) transform) sync* {
    var index = 0;
    for (final element in this) {
      yield transform(index, element);
      index++;
    }
  }

  List<List<T>> chunked(int size) {
    if (size <= 0) return <List<T>>[];
    final list = toList();
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += size) {
      final end = (i + size < list.length) ? i + size : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }

  List<T> sorted([int Function(T a, T b)? compare]) {
    final list = toList();
    list.sort(compare);
    return list;
  }
}

extension IterableNullableX<T> on Iterable<T?> {
  Iterable<T> whereNotNull() => whereType<T>();
}
