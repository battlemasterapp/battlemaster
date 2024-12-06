extension CustomExtenstions<T> on List<T> {
  List<T> intercalate(T element) {
    if (isEmpty) {
      return [];
    }
    final result = <T>[];
    for (var i = 0; i < length - 1; i++) {
      result.add(this[i]);
      result.add(element);
    }
    result.add(last);
    return result;
  }
}