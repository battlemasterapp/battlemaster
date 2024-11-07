extension SignString on int {
  String get signString => this >= 0 ? '+$this' : '$this';
}