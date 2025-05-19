extension CapitalizeString on String? {
  String capitalize() {
    if (this == null) return this ?? '';
    if (this!.isEmpty || this!.length == 1) return this!.toUpperCase();
    return '${this![0].toUpperCase()}${this!.substring(1)}';
  }

  String capitalizeAll() {
    if (this?.isEmpty ?? true) {
      return "";
    }
    return this!.split(" ").map((e) => e.capitalize()).join(" ");
  }
}
