extension SignString on int? {
  String get signString {
    if (this == null) {
      return '';
    }
    return this! >= 0 ? '+$this' : '$this';
  }

  String get ordinal {
    if (this == null) {
      return '';
    }

    final absValue = this!.abs();
    if (absValue % 100 >= 11 && absValue % 100 <= 13) {
      return '${this}th';
    }
    switch (absValue % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }
}
