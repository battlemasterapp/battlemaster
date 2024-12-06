extension CapitalizeString on String? {
  String capitalize() {
    if (this == null) return '';
    return '${this![0].toUpperCase()}${this!.substring(1)}';
  }

  String capitalizeAll() {
    if (this?.isEmpty ?? true) {
      return "";
    }
    return this!.split(" ").map((e) => e.capitalize()).join(" ");
  }
}
